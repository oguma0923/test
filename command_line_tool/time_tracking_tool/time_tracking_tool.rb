require './task'
require './task_manager'
require 'yaml'
require 'date'

class TimeTrackingTool
  include TaskManager
  def initialize
    @tasks = load_tasks
  rescue Errno::ENOENT
    @tasks = []
  end

  def self.main(option, task_name)
    tool = TimeTrackingTool.new
    case option
    when '-s' || '--start'
      tool.start(task_name)
    when '-f' || '--finish'
      tool.finish(task_name)
    when '-vt' || '--view-today'
      tool.view_today
    when '-vw' || '--view-week'
      tool.view_week
    else
      tool.usage
    end
  end

  def start(task_name)
    new_task = Task.new(Date.today, task_name, Time.now)
    add(new_task, @tasks)
    save(@tasks)
  end

  def finish(task_name)
    target_task = @tasks[get_index(task_name, @tasks)]
    target_task.finish_time = Time.now
    target_task.state = 2
    save(@tasks)
  end
end

TimeTrackingTool.main(ARGV[0], ARGV[1]) if __FILE__ == $0
