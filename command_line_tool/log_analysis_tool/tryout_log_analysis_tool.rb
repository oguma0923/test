require './read_log'
class TimeTrackingTool
  include ReadLog

  def self.main
    tool = TimeTrackingTool.new
    case ARGV[0]
    when '-a' || '--actual'
      tool.actual
    when '-d' || '--difference'
      tool.difference
    when '-s' || '--subject'
      tool.subject
    else
      tool.usage
    end
  end

  def actual
    logs = read_log_for_actual
    total_time = 0
    puts '稼働日       実績時間'
    logs.each do |log|
      total_time += log.daily_actual_time
      log.show
    end
    puts "\r\n合計稼働時間\r\n#{total_time}時間"
  end

  def difference
    logs = read_log_for_difference
    puts '稼働日        見積もり時間   実績時間    差分'
    logs.each(&:show)
  end

  def subject
    time_per_subject = read_log_for_subject
    puts '題目毎の実績時間'
    time_per_subject.each do |key, value|
      puts format('%<subject>7s%<time>6.1f時間', subject: key, time: value)
    end
  end

  def usage
    puts 'usage: ruby tryout_log_analysis_tool.rb [-a|--actual] [-d|--difference] [-s|--subject]'
  end
end

TimeTrackingTool.main
