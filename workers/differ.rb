class Differ
  include Sidekiq::Worker

  def perform(task_id, original_download_time_string)
    task = Task.find(task_id)

    diff_line = diff_index_of_last_two_files(task_id, task.selector)

    LogItem.new('sidekiq', "#{Time.now} Started file diff for task #{task_id}\nDiff line: #{diff_line}").save

    if diff_line
      LogItem.new('diff', "#{Time.now} There were some differences. Sending notification").save
      Notifier.perform_async(task.id, original_download_time_string)
    else
      LogItem.new('diff', "#{Time.now} No differences - not sending notification").save
    end
  end

  private

  def latest_two_files(task_id)
    downloaded_files = Dir['download/*'].select do |file_name|
      file_name.start_with?('download/' + task_id.to_s + '-')
    end

    downloaded_files.sort.last(2)
  end

  def diff_index_of_last_two_files(task_id, css_selector = 'html')
    old_file_name, new_file_name = latest_two_files(task_id)

    LogItem.new('diff', "Old file name: #{old_file_name}\nNew file name: #{new_file_name}").save

    if old_file_name and new_file_name
      old_file = Nokogiri::HTML(File.open(old_file_name, 'r')).css(css_selector)
      new_file = Nokogiri::HTML(File.open(new_file_name, 'r')).css(css_selector)

      new_file.zip(old_file).find_index do |new_item, old_item|
        new_item.to_s != old_item.to_s
      end
    end
  end
end
