class LogItem
  def initialize(log_name, message)
    @log_directory = APP_DIRECTORY + '/logs/'
    @log_name = log_name
    @message = message
  end

  def save
    open(@log_directory + @log_name + '.log', 'a') do |f|
      f.puts @message
    end
  end
end
