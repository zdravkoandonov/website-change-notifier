require 'net/http'
require 'net/smtp'

class ChangeNotifier
  attr_reader :last_change_line

  def initialize(url)
    @url = url

  end

  def dl
    now = Time.now
    response = Net::HTTP.get_response(URI(@url))
    File.write("dl#{@url.gsub(/http:|\/|\\|\./, '')}#{now.strftime('%Y%m%d%H%M%S%L')}", response.body)
  end

  def send_email
    message = <<MESSAGE_END
From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>
To: Zdravko Andonov <zdravko.andonov.dev@gmail.com>
Subject: Change detected at #{@url} - #{Time.now}

There is a change detected at the following url on line #{@last_change_line+1}: #{@url}

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

  def diff_last_two_txts
    latest_files = Dir["*"].select { |file_name| file_name.start_with?("dl") }.sort
    old_file = File.open(latest_files[-2], 'r')
    new_file = File.open(latest_files[-1], 'r')
    zipped = new_file.each_line.zip(old_file.each_line)
    @last_change_line = zipped.find_index { |new_line, old_line| new_line != old_line }
  end
end

credoweb_robots_notifier = ChangeNotifier.new("http://www.credoweb.bg/robots.txt")
credoweb_robots_notifier.dl
credoweb_robots_notifier.diff_last_two_txts
if credoweb_robots_notifier.last_change_line
  credoweb_robots_notifier.send_email
end
