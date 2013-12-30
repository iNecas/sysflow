module Sysflow
  module Actions
    class BulkAction < ::Actions::EntryAction

      def plan(action_class, inputs)
        inputs.each do |input|
          plan_action(action_class, input)
        end
        plan_self(action_class: action_class.name, inputs: inputs)
      end

      def task_output
        self.all_actions.select do |action|
          action.action_class.name == input[:action_class]
        end.map do |action|
          { input:  action.input,
            output: action.output }
        end
      end

    end
  end
end
