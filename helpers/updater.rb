module Updater
  def download_content(task_id)
    task = Task.find(task_id)

    now = Time.now
    response = Net::HTTP.get_response(URI(task.page.url))

    File.write("/home/zdravkoandonov/Source/Repos/website-change-notifier/download/#{task.id}-#{now.strftime('%Y%m%d%H%M%S%L')}", response.body)

    task.last_updated = now
    task.save

    open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/downloads.log', 'a') do |f|
      f.puts now.to_s + ' Downloaded ' + task.page.url
    end
  rescue Exception => exception
    open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/downloads.log', 'a') do |f|
      f.puts now.to_s + ' ' + exception.to_s
    end
  end

  def diff_index_of_last_two_txts(task_id, css_selector = 'html')
    downloaded_files = Dir['download/*'].select do |file_name|
      open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/diff.log', 'a') do |f|
        f.puts file_name
      end
      file_name.start_with?('download/' + task_id.to_s + '-')
    end

    latest_files = downloaded_files.sort

    if latest_files.size >= 2
      old_file = Nokogiri::HTML(File.open(latest_files[-2], 'r')).css(css_selector)
      new_file = Nokogiri::HTML(File.open(latest_files[-1], 'r')).css(css_selector)

      zipped = new_file.zip(old_file)

      open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/diff.log', 'a') do |f|
        f.puts 'Diff files: ' + zipped.inspect
        f.puts old_file
        f.puts new_file
      end

      zipped.find_index { |new_item, old_item| new_item.to_s != old_item.to_s }
    end
  end
end
