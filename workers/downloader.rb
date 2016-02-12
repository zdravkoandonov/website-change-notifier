class Downloader
  include Sidekiq::Worker

  def perform(task_id)
    now = Time.now

    LogItem.new('sidekiq', "#{now} Started downloading task with id: #{task_id}").save

    download_content(task_id)
    Differ.perform_async(task_id, now.to_s)
  end

  private

  def download_content(task_id)
    task = Task.find(task_id)
    now = Time.now
    response = Net::HTTP.get_response(URI(task.page.url))

    File.write("#{APP_DIRECTORY}/download/#{task.id}-#{now.strftime('%Y%m%d%H%M%S%L')}", response.body)

    task.last_updated = now
    task.save

    LogItem.new('downloads', "#{now} Downloaded #{task.page.url}").save
  rescue StandardError => exception
    LogItem.new('downloads', "#{now} #{exception}").save
  end
end
