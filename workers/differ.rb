class Differ
  include Sidekiq::Worker
  include Updater

  def perform(task_id)
    task = Task.find(task_id)

    diff_line = diff_index_of_last_two_txts(task_id, task.selector)

    LogItem.new('sidekiq', "#{Time.now} Started file diff for task #{task_id}\nDiff line: #{diff_line}").save

    if diff_line
      Emailer.perform_async(task.user.email, task.page.url, diff_line, Time.now.to_s)
    else
      # log no differences
    end
  end
end
