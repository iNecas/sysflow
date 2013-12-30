class CommandsController < ApplicationController

  def index
    @commands = (["#{Rails.root}/bin/cmd_demo"] * 3).join("\n")
  end

  def show
    @task = Dyntask::Task.find(params[:id])
  end

  def create
    commands = params[:commands].split("\n").select(&:present?).map do |cmd|
      { cmd: cmd }
    end
    if commands.any?
      task = Dyntask.async_task(Sysflow::Actions::BulkAction,
                                Sysflow::Actions::Command,
                                commands)
      redirect_to(command_path(id: task.id))
    else
      redirect_to(commands_path, alert: "Specify at least one command")
    end
  end
end
