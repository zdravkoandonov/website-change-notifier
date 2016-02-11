class Downloader
  include Sidekiq::Worker
  include Updater

  def perform(task_id)
    now = Time.now

    LogItem.new('sidekiq', "#{now} Started downloading task with id: #{task_id}").save

    download_content(task_id)
    Differ.perform_async(task_id)
  end
end
