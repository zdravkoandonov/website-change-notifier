class Notifier
  include Sidekiq::Worker

  def perform(task_id, original_download_time_string)
    task = Task.find(task_id)
    url = task.page.url
    user = task.user
    platform = user.platform.name.downcase.to_sym
    email_address = user.email
    webhook_url = user.slack_url
    bot_name = user.slack_bot_name

    message = DiffMessage.new(url, original_download_time_string, platform, email_address)

    LogItem.new('sidekiq', "#{Time.now} Started emailing for #{url} - #{email_address}\n#{message}").save

    notification = Notification.new(
      message.to_s,
      platform,
      email_address: email_address,
      webhook_url: webhook_url,
      bot_name: bot_name)
    notification.send
  end
end
