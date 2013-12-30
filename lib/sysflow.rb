require 'sysflow/version'
require 'sysflow/system_connector'

module Sysflow

  # Preparing the usage of Sysflow actions in Dynflow. If Dyntask (or
  # other compatible module) is present in the system, it adds the
  # actions path to the eager_load_paths. Otherwise, it requires
  # the actions directly.
  def self.dynflow_load(dyntask_module = nil)
    Sysflow::SystemConnector.initialize
    unless dyntask_module
      dyntask_module = Dyntask if defined? Dyntask
    end
    if dyntask_module
      dyntask_module.eager_load_paths << actions_path
    else
      Dir[File.join(actions_path, "**", "*")].each { |f| require f }
    end
  end

  def self.actions_path
    File.expand_path("../sysflow/actions", __FILE__)
  end

end
