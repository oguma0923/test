class ActualTimeLog
  attr_reader :daily_actual_time, :date

  def initialize(date, daily_actual_time)
    @date = date
    @daily_actual_time = daily_actual_time
  end

  def show
    puts "#{@date}   #{@daily_actual_time}時間"
  end
end
