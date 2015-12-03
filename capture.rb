require 'screencap'

def capture(url)
  puts "starting..."
  f = Screencap::Fetcher.new(url)
  puts "going on..."
  screenshot = f.fetch(output: 'data/screenshot.png', width: 1024)
  puts "saving..."
end

capture("http://fmi.ruby.bg")
