class Differ
  include Sidekiq::Worker
  include Updater

  def perform(task_id)
    task = Task.find(task_id)

    diff_line = diff_index_of_last_two_txts(task_id, task.selector)

    open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/sidekiq.log', 'a') do |f|
      f.puts Time.now.to_s + ' Started file diff for task with id: ' + task_id.to_s
      f.puts "Diff line: " + diff_line.to_s
    end

    if diff_line
      Emailer.perform_async(task.user.email, task.page.url, diff_line, Time.now.to_s)
    else
      # log no differences
    end
  end
end
