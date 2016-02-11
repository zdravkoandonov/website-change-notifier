class Notification
  def initialize(message, platform, **settings)
    @message = message
    @platform = platform
    @settings = settings
  end

  def send
    case @platform
      when :email then send_email
      when :slack then send_slack
    end
  end

  private

  def send_email
    email_address = @settings[:email_address]

    Net::SMTP.start('mail.zdravkoandonov.com',
                    26,
                    'localhost',
                    'notifier@zdravkoandonov.com',
                    'asdf1234!@#$',
                    :plain) do |smtp|
      smtp.send_message @message, 'notifier@zdravkoandonov.com', email_address
    end
  end

  def send_slack

  end
end
