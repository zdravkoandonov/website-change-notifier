require 'net/http'
require 'net/smtp'

class ChangeNotifier
  attr_reader :last_change_line

  def initialize(*settings)
    @settings = settings
  end

  def update_all
    @settings.each do |url, start_line|
      dl(url)
      last_change_line = diff_last_two_txts(url, start_line)
      p last_change_line
      if last_change_line
        send_email(url, last_change_line + 1)
      end
    end
  end

  def dl(url)
    now = Time.now
    response = Net::HTTP.get_response(URI(url))

    File.write("#{url.gsub(/http:|\/|\\|\./, '')}#{now.strftime('%Y%m%d%H%M%S%L')}", response.body)
  end

  def diff_last_two_txts(url, start_line = 0)
    latest_files = Dir["*"].select { |file_name| file_name.start_with?(url.gsub(/http:|\/|\\|\./, '')) }.sort
    if latest_files.size >= 2
      old_file = File.open(latest_files[-2], 'r')
      new_file = File.open(latest_files[-1], 'r')
      zipped = new_file.each_line.zip(old_file.each_line)
      zipped[start_line..-1].find_index { |new_line, old_line| new_line != old_line }
    end
  end

  def send_email(url, line)
    message = <<MESSAGE_END
From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>
To: Zdravko Andonov <zdravko.andonov.dev@gmail.com>
Subject: Change detected at #{url} - #{Time.now}

There is a change detected at the following url on line #{line}: #{url}

MESSAGE_END

    Net::SMTP.start('mail.zdravkoandonov.com',
                    26,
                    'localhost',
                    'notifier@zdravkoandonov.com',
                    'Secret1!',
                    :plain) do |smtp|
      smtp.send_message message, 'notifier@zdravkoandonov.com', 'zdravko.andonov.dev@gmail.com'
    end
  end
end

urls_to_track = [["http://www.credoweb.bg/robots.txt", 0], ["http://fmi.ruby.bg/", 11]]
ChangeNotifier.new(*urls_to_track).update_all
