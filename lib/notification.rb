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
    webhook_url = @settings[:webhook_url]
    bot_name = @settings[:bot_name]
    bot_name = 'change-notifier' if bot_name == ''

    LogItem.new('slack', webhook_url).save
    LogItem.new('slack', bot_name).save

    notifier = Slack::Notifier.new(
      webhook_url,
      username: bot_name)
    notifier.ping(@message)
  end
end
