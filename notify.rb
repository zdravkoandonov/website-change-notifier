require 'net/smtp'

message = <<MESSAGE_END
From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>
To: Zdravko Andonov <zdravko.andonov.dev@gmail.com>
Subject: CredoWeb - robots.txt is changed - #{Time.now}

There is a change in the robots.txt - http://www.credoweb.bg/robots.txt

MESSAGE_END


Net::SMTP.start('mail.zdravkoandonov.com',
                26,
                'localhost',
                'notifier@zdravkoandonov.com',
                'Secret1!',
                :plain) do |smtp|
  smtp.send_message message, 'notifier@zdravkoandonov.com', 'zdravko.andonov.dev@gmail.com'
end
