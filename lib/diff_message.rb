class DiffMessage
  def initialize(email_address, url, diff_line, time_string)
    @email_address = email_address
    @url = url
    @diff_line = diff_line
    @time_string = time_string
  end

  def to_s
    "From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>\n" +
      "To: <#{@email_address}>\n" +
        "Subject: Change detected at #{@url} - #{@time_string}\n" +
          "There is a change detected at #{@url} on line #{@diff_line}."
  end
end
