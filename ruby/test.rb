require 'csv'
require 'date'
require 'time'

class Task
  attr_accessor :start_time, :stop_time
  attr_reader :date, :name

  def initialize(date, name, start_time, stop_time)
    @date = date
    @name = name
    @start_time = start_time
    @stop_time = stop_time
    @formatted_start_time = @start_time.strftime('%Y-%m-%d %H:%M:%S')
    return if @stop_time.nil?

    @formatted_stop_time = @stop_time.strftime('%Y-%m-%d %H:%M:%S')
    @actual_time = @stop_time - @start_time
  end

  def to_array
    if @stop_time.nil?
      [@date, @name, @formatted_start_time, nil]
    else
      [@date, @name, @formatted_start_time, @formatted_stop_time]
    end
  end

  def to_view
    if @stop_time.nil?
      "#{@formatted_start_time} ~ #{' ' * 28} #{@name}"
    else
      "#{@formatted_start_time} ~ #{@formatted_stop_time} #{Time.at(@actual_time).utc.strftime('%X')} #{@name}"
    end
  end
end

class TimeTrackingTool
  def initialize
    @tasks = []
    @exists = File.exist?('time_tracking.csv')
    return unless @exists

    CSV.foreach('time_tracking.csv') do |task|
      if task[3].nil?
        @tasks.push(Task.new(Date.parse(task[0]), task[1], Time.parse(task[2]), nil))
      else
        @tasks.push(Task.new(Date.parse(task[0]), task[1], Time.parse(task[2]), Time.parse(task[3])))
      end
    end
  end

  def start(name)
    new_task = Task.new(Date.today, name, Time.now, nil)
    CSV.open('time_tracking.csv', 'a') do |csv|
      csv << new_task.to_array
    end
  end

  def stop(name)
    index = @tasks.index { |task| task.name == name && !task.stop_time.nil? }
    raise '計測が開始されていません' if @exists && index.nil?

    @tasks[index].stop_time = Time.now
    CSV.open('time_tracking.csv', 'w') do |csv|
      @tasks.each do |task|
        p task
        csv << task.to_array
      end
    end
  end

  def view_today
    raise '記録が存在しません' unless @exists

    today_tasks = @tasks.select { |today_task| today_task.date == Date.today }
    total_time = 0
    puts "#{'開始時刻'.ljust(17)} #{'終了時刻'.ljust(15)} 実績時間 タスク名"
    today_tasks.each do |task|
      puts task.to_view
      total_time += task.stop_time - task.start_time unless task.stop_time.nil?
    end
    puts Time.at(total_time).utc.strftime('%X')
  end
end

# test = TimeTrackingTool.new
# test.start('test')
# sleep(2)
# test = TimeTrackingTool.new
# test.stop
# test = TimeTrackingTool.new
# test.view_today
