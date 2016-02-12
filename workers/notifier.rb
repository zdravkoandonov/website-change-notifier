class Notifier
  include Sidekiq::Worker

  def perform(task_id, time_string)
    task = Task.find(task_id)
    url = task.page.url
    user = task.user
    platform = user.platform.name.downcase.to_sym
    email = user.email

    message = DiffMessage.new(url, time_string, platform, email)

    send_notification(url, platform, email, message, user)
  end

  private

  def send_notification(url, platform, email, message, user)
    log_message = "#{Time.now} Started sending notification for #{url} - " \
      "#{email}\n#{message}"
    LogItem.new('sidekiq', log_message).save

    notification = Notification.new(message.to_s,
                                    platform,
                                    email_address: email,
                                    webhook_url: user.slack_url,
                                    bot_name: user.slack_bot_name)
    notification.send
  end
end
