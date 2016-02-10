class Waker
  include Sidekiq::Worker
  include Updater

  def perform
    now = Time.now

    open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/sidekiq.log', 'a') do |f|
      f.puts now.to_s + ' Started waker'
    end

    # TODO: use in-SQL filtering
    Task.find_each(batch_size: 2000) do |task|

      open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/sidekiq.log', 'a') do |f|
        f.puts now.to_s + ' Checked ' + task.inspect
      end

      if task.last_updated + task.frequency.minutes <= now
        download_content(task.id)
        Differ.perform_async(task.id)
      end
    end

    Waker.perform_in(1.minute)
  end
end
