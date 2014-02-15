class CommandsController < ApplicationController

  def index
    @commands = (["#{Rails.root}/bin/cmd_demo"] * 3).join("\n")
  end

  def show
    @task = Dyntask::Task.find(params[:id])
  end

  def create
    commands = []
    if params[:commands].is_a? String
      commands = params[:commands].split("\n").select(&:present?).map do |cmd|
        { cmd: cmd }
      end
    elsif params[:commands].is_a? Array
      commands = params[:commands].map { |command| { cmd: command } }
    end
    if commands.any?
      task = Dyntask.async_task(Sysflow::Actions::BulkAction,
                                Sysflow::Actions::Command,
                                commands)
      respond_to do |format|
        format.html { redirect_to(command_path(id: task.id)) }
        format.json { render_task(task) }
      end

    else
      redirect_to(commands_path, alert: "Specify at least one command")
    end
  end

  protected

  def render_task(task)
    render 'dyntask/api/tasks/show', :locals => { :task => task }
  end
end
