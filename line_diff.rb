class ChangeNotifier
  def diff_txt
    latest_files = Dir["*"].select { |file_name| file_name.start_with?("dl") }.sort
    old_file = File.open(latest_files[-2], 'r')
    new_file = File.open(latest_files[-1], 'r')
    zipped = new_file.each_line.zip(old_file.each_line)
    @last_change_line = zipped.find_index { |new_line, old_line| new_line != old_line }
  end
end
