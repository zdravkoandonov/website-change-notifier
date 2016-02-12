class Waker
  include Sidekiq::Worker

  def perform
    start_downloaders

    Waker.perform_in(1.minute)
  end

  private

  def start_downloaders
    now = Time.now

    LogItem.new('sidekiq', "#{now} Started waker").save

    # TODO: use in-SQL filtering
    Task.find_each(batch_size: 2000) do |task|
      LogItem.new('sidekiq', "#{now} Checking #{task.inspect}").save

      if task.last_updated + task.frequency.minutes <= now
        Downloader.perform_async(task.id)
      end
    end
  end
end
