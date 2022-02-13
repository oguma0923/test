class DifferenceLog
  attr_reader :date

  def initialize(date, estimated_time, actual_time)
    @date = date
    @estimated_time = estimated_time
    @actual_time = actual_time
    @difference_time = (actual_time - estimated_time)
  end

  def show
    puts format('%<date>s%<time1>9.1f時間%<time2>9.1f時間%<time3>+9.1f時間',
                date: @date, time1: @estimated_time, time2: @actual_time, time3: @difference_time)
  end
end
