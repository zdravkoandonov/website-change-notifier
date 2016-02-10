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

  def diff_index_of_last_two_txts(task_id)
    downloaded_files = Dir['download/*'].select do |file_name|
      open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/diff.log', 'a') do |f|
        f.puts file_name
      end
      file_name.start_with?('download/' + task_id.to_s + '-')
    end

    latest_files = downloaded_files.sort

    open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/diff.log', 'a') do |f|
      f.puts 'Diff files: ' + latest_files.inspect
    end

    if latest_files.size >= 2
      old_file = File.open(latest_files[-2], 'r')
      new_file = File.open(latest_files[-1], 'r')

      zipped = new_file.each_line.zip(old_file.each_line)
      zipped.find_index { |new_line, old_line| new_line != old_line }
    end
  end

  def send_email(email_address, url, diff_line, time_string)
    message = <<MESSAGE
From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>
To: <#{email_address}>
Subject: Change detected at #{url} - #{time_string}
There is a change detected at the following url on line #{diff_line}: #{url}
MESSAGE

    Net::SMTP.start('mail.zdravkoandonov.com',
                    26,
                    'localhost',
                    'notifier@zdravkoandonov.com',
                    'asdf1234!@#$',
                    :plain) do |smtp|
      smtp.send_message message, 'notifier@zdravkoandonov.com', email_address
    end
  end
end
