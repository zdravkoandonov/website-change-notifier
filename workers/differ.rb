class Differ
  include Sidekiq::Worker

  def perform(task_id, original_download_time_string)
    log_message = "#{Time.now} Started file diff for task #{task_id}"
    LogItem.new('sidekiq', log_message).save

    diff_line = diff_last_two_files(task_id, Task.find(task_id).selector)

    if diff_line
      log_message = "#{Time.now} There were differences. Sending notification"
      Notifier.perform_async(task_id, original_download_time_string)
    else
      log_message = "#{Time.now} No differences - not sending notification"
    end

    LogItem.new('diff', log_message).save
  end

  private

  def latest_two_files(task_id)
    downloaded_files = Dir['download/*'].select do |file_name|
      file_name.start_with?('download/' + task_id.to_s + '-')
    end

    downloaded_files.sort.last(2)
  end

  def diff_last_two_files(task_id, css_selector = 'html')
    old_file_name, new_file_name = latest_two_files(task_id)

    if old_file_name and new_file_name
      old_file = Nokogiri::HTML(File.open(old_file_name, 'r')).css(css_selector)
      new_file = Nokogiri::HTML(File.open(new_file_name, 'r')).css(css_selector)

      new_file.zip(old_file).find_index do |new_item, old_item|
        new_item.to_s != old_item.to_s
      end
    end
  end
end
