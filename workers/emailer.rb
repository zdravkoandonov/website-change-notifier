class Emailer
  include Sidekiq::Worker
  include Updater

  def perform(email, url, diff_line, original_download_time_string)
    open('/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/sidekiq.log', 'a') do |f|
      f.puts Time.now.to_s + " Started emailing for #{url} - #{email}"
    end

    send_email(email, url, diff_line, original_download_time_string)
  end
end
