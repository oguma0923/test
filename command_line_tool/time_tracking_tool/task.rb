class Task
  attr_reader :name, :date
  attr_accessor :state, :finish_time

  ONGOING = 0
  PAUSED = 1
  FINISHED = 2
  def initialize(date, name, start_time)
    @date = date
    @name = name
    @state = ONGOING
    @start_time = start_time
    @pause_times = []
    @finish_time = nil
  end
end
