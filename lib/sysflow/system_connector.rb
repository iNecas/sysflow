module Sysflow
  # Service that handles running external commands for Actions::Command
  # Dynflow action. It runs just one (actor) thread for all the commands
  # running in the system and updates the Dynflow actions periodically.
  class SystemConnector < Dynflow::MicroActor

    include Algebrick::Matching

    # command comming from action
    Command = Algebrick.type do
      fields(cmd: String,
             suspended_action: Dynflow::Action::Suspended)
    end

    # process running the action
    Process = Algebrick.type do
      fields(command: Command,
             pid:     Integer,
             out:     IO)
    end

    # periodic event refreshing the actions with current data
    RefreshActions = Algebrick.atom

    # event striggered when process is started to propagate send
    # the pid to the suspended action
    StartedAction = Algebrick.type do
      fields process:     Process
    end

    # event triggered when some process is finished, cauing the immediate update
    # of the action
    FinishedAction = Algebrick.type do
      fields process:     Process,
          exit_status: Integer
    end

    # event sent to the action with the update data
    ProcessUpdate = Algebrick.type do
      fields(pid:         Integer,
             lines:       String,
             exit_status: type { variants(NilClass, Integer) } )
    end

    # message causing waiting for more output
    Wait = Algebrick.atom

    def self.initialize
      @instance = self.new
    end

    def self.instance
      @instance
    end

    def initialize(logger = Rails.logger, *args)
      super
      @process_by_output = {}
      @process_buffer = {}
      @refresh_planned = false
    end

    def run_cmd(cmd, suspended_action)
      self << Command[cmd, suspended_action]
    end

    def on_message(message)
      match(message,
            on(~Command) do |command|
              initialize_command(command)
              plan_next_refresh
            end,
            on(StartedAction.(~any)) do |process|
              refresh_action(process)
            end,
            on(RefreshActions) do
              refresh_actions
              @refresh_planned = false
              plan_next_refresh
            end,
            on(FinishedAction.(~any, ~any)) do |process, exit_status|
              refresh_action(process, @process_buffer[process], exit_status)
            end,
            on(Wait) do
              wait
            end)

      if @mailbox.empty? && outputs.any?
        self << Wait
      end
    end

    def initialize_command(command)
      pout = IO.popen(command[:cmd])
      process = Process[command, pout.pid, pout]
      @process_by_output[pout] = process
      @process_buffer[process] = ""
    end

    def clear_process(process)
      @process_by_output.delete(process[:out])
      @process_buffer.delete(process)
    end

    def refresh_action(process, lines = "", exit_status = nil)
      return unless @process_buffer.has_key?(process)
      @process_buffer[process] = ""

      process[:command][:suspended_action] << ProcessUpdate[process[:pid],
                                                            lines,
                                                            exit_status]
      if exit_status
        clear_process(process)
      end
    end

    def refresh_actions
      @process_by_output.values.each do |process|
        lines = @process_buffer[process]
        refresh_action(process, lines) unless lines.empty?
      end
    end

    def plan_next_refresh
      if outputs.any? && !@refresh_planned
        Dyntask.world.clock.ping(self, Time.now + refresh_interval, RefreshActions)
        @refresh_planned = true
      end
    end

    def refresh_interval
      1
    end

    def wait
      ready_outputs, * = IO.select(outputs, nil, nil, 0.1)
      return unless ready_outputs
      ready_outputs.each do |ready_output|
        process = @process_by_output[ready_output]
        line = ready_output.gets

        if line
          @process_buffer[process] << line
        else
          ready_output.close
          self << FinishedAction[process, $?.exitstatus]
        end
      end
    end

    def outputs
      @process_by_output.values.map { |process| process[:out] }
    end
  end
end
