module Sysflow
  module Actions
    class Command < ::Actions::EntryAction

      include Algebrick::Matching

      input_format do
        param :cmd, String
      end

      def run(event = nil)
        match(event,
              on(nil) do
                init_run
                suspend do |suspended_action|
                  SystemConnector.instance.run_cmd(cmd, suspended_action)
                end
              end,
              on(~SystemConnector::ProcessUpdate) do |process_update|
                self.pid   = process_update[:pid]
                self.lines = process_update[:lines] unless process_update[:lines].empty?

                if process_update[:exit_status]
                  self.exit_status = process_update[:exit_status]
                else
                  suspend
                end
              end)
      end

      def init_run
        output[:result] = ""
      end

      def cmd
        input[:cmd]
      end

      def pid=(pid)
        output[:pid] ||= pid
      end

      # when the process finishes, this method is called with
      # its exit status
      def exit_status=(exit_status)
        output[:exit_status] = exit_status
      end

      # every time new lines come from the command, this method is called
      def lines=(lines)
        output[:result] << lines
      end

    end
  end
end
