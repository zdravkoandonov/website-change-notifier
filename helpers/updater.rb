module Updater
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

  def diff_index_of_last_two_txts(task_id, css_selector = 'html')
    downloaded_files = Dir['download/*'].select do |file_name|
      LogItem.new('diff', file_name).save
      file_name.start_with?('download/' + task_id.to_s + '-')
    end

    latest_files = downloaded_files.sort

    if latest_files.size >= 2
      old_file = Nokogiri::HTML(File.open(latest_files[-2], 'r')).css(css_selector)
      new_file = Nokogiri::HTML(File.open(latest_files[-1], 'r')).css(css_selector)

      zipped = new_file.zip(old_file)

      LogItem.new('diff', "Diff files: #{zipped.inspect}\n#{old_file}\n#{new_file}").save

      zipped.find_index { |new_item, old_item| new_item.to_s != old_item.to_s }
    end
  end
end
