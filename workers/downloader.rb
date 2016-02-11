class Downloader
  include Sidekiq::Worker

  def perform(task_id)
    now = Time.now

    LogItem.new('sidekiq', "#{now} Started downloading task with id: #{task_id}").save

    download_content(task_id)
    Differ.perform_async(task_id)
  end

  private

  def download_content(task_id)
    task = Task.find(task_id)
    now = Time.now
    response = Net::HTTP.get_response(URI(task.page.url))

    File.write("/home/zdravkoandonov/Source/Repos/website-change-notifier/download/#{task.id}-#{now.strftime('%Y%m%d%H%M%S%L')}", response.body)

    task.last_updated = now
    task.save

    LogItem.new('downloads', "#{now} Downloaded #{task.page.url}").save
  rescue Exception => exception
    LogItem.new('downloads', "#{now} #{exception}").save
  end
end
