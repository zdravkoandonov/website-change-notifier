class LogItem
  def initialize(log_name, message)
    @log_dir = '/home/zdravkoandonov/Source/Repos/website-change-notifier/logs/'
    @log_name = log_name
    @message = message
  end

  def save
    open(@log_dir + @log_name + '.log', 'a') do |f|
      f.puts @message
    end
  end
end
