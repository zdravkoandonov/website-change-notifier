class Downloader
  include Sidekiq::Worker

  def perform(task_id)
    now = Time.now

    log_message = "#{now} Started downloading task with id: #{task_id}"
    LogItem.new('sidekiq', log_message).save

    download_content(task_id, now)
    Differ.perform_async(task_id, now.to_s)
  end

  private

  def download_content(task_id, now)
    task = Task.find(task_id)

    save_response(task_id, now, task.page.url)

    task.last_updated = now
    task.save
  end

  def save_response(task_id, time, url)
    response = Net::HTTP.get_response(URI(url))

    formatted_time = time.strftime('%Y%m%d%H%M%S%L')
    file_name = "#{APP_DIRECTORY}/download/#{task_id}-#{formatted_time}"
    File.write(file_name, response.body)

    LogItem.new('downloads', "#{time} Downloaded #{url}").save
  rescue StandardError => exception
    LogItem.new('downloads', "#{time} #{exception}").save
  end
end
