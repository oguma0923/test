require './actual_time_log'
require './difference_log'
require 'date'

module ReadLog
  def read_log_for_actual
    logs = []
    Dir.glob('../../log/**/*.txt') do |log_name|
      date = Date.parse(File.basename(log_name, '.txt'))
      File.open(log_name) do |log|
        line = log.readline(chomp: true) while line != '・1日の実績時間'
        time = log.readline.slice(/\d+(\.\d+)?/).to_f
        logs.push(ActualTimeLog.new(date, time))
      end
    end
    logs.sort_by(&:date)
  end

  def read_log_for_difference
    logs = []
    Dir.glob('../../log/**/*.txt') do |log_filename|
      date = Date.parse(File.basename(log_filename, '.txt'))
      File.open(log_filename) do |log|
        estimated_time = 0
        actual_time = 0
        line = log.readline(chomp: true) while line != '・見積もり時間'
        while (line = log.readline(chomp: true)) != ''
          estimated_time += line.slice(/\d+(\.\d+)?/).to_f
        end
        line = log.readline(chomp: true) while line != '・実績時間'
        while (line = log.readline(chomp: true)) != ''
          actual_time += line.slice(/\d+(\.\d+)?/).to_f
        end
        logs.push(DifferenceLog.new(date, estimated_time, actual_time))
      end
    end
    logs.sort_by(&:date)
  end

  def read_log_for_subject
    time_per_subject = { git: 0.0, shell: 0.0, ruby: 0.0, clitool: 0.0 }
    Dir.glob('../../log/**/*.txt') do |log_filename|
      subjects = []
      File.open(log_filename) do |log|
        log.readline
        while (line = log.readline(chomp: true)) != ''
          scaned_line = line.scan(/(git|shell|ruby|cliツール):/)
          subjects.push(scaned_line[0][0].intern) unless scaned_line.empty?
        end
        line = log.readline(chomp: true) while line != '・実績時間'
        subjects.each do |subject|
          line = log.readline(chomp: true)
          time_per_subject[subject] += line.slice(/\d+(\.\d+)?/).to_f
        end
      end
    end
    time_per_subject
  end
end
