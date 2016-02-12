class DiffMessage
  def initialize(url, time_string, platform, email_address = nil)
    @platform = platform
    @email_address = email_address
    @url = url
    @time_string = time_string
  end

  def to_s
    if @platform == :email
      email_message
    else
      simple_message
    end
  end

  private

  def email_message
    "From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>\n" +
      "To: <#{@email_address}>\n" +
        "Subject: Change detected at #{@url} - #{@time_string}\n" +
          "There is a change detected at #{@url}."
  end

  def simple_message
    "#{@time_string}: There is a change detected at #{@url}."
  end
end
