class Downloader
  include Sidekiq::Worker
  include Updater

  def perform(task_id)
    now = Time.now

    open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/sidekiq.log', 'a') do |f|
      f.puts now.to_s + ' Started downloading task with id: ' + task_id.to_s
    end

    download_content(task_id)
    Differ.perform_async(task_id)
  end
end
