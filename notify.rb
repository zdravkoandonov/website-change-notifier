require 'net/smtp'

class ChangeNotifier
  def notify
    send_email
  end

  def send_email(url)
    message = <<MESSAGE_END
From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>
To: Zdravko Andonov <zdravko.andonov.dev@gmail.com>
Subject: Change detected at #{url} - #{Time.now}

There is a change detected at the following url on line #{@last_change_line}: #{url}

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

ChangeNotifier.new.send_email("")
