class Emailer
  include Sidekiq::Worker

  def perform(email, url, diff_line, original_download_time_string)
    message = DiffMessage.new(email, url, diff_line, original_download_time_string)

    LogItem.new('sidekiq', "#{Time.now} Started emailing for #{url} - #{email}\n #{message}").save

    Notification.new(message.to_s, :email, email_address: email).send
  end
end
