require './task'

module TaskManager
  def load_tasks
    open('tasks.yml', 'r') { |file| YAML.safe_load(file, [Date, Time, Task]) }
  end

  def save(tasks)
    YAML.dump(tasks, File.open('tasks.yml', 'w'))
  end

  def add(new_task, tasks)
    raise '同名の未完了タスクが存在します' if get_index(new_task.name, tasks)

    tasks.push(new_task)
  end

  def get_index(task_name, tasks)
    tasks.index { |task| task.name == task_name }
  end
end
