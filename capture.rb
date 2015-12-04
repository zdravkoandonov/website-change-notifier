require 'screencap'
require 'net/http'

def capture(url)
  puts "starting..."
  f = Screencap::Fetcher.new(url)
  puts "going on..."
  screenshot = f.fetch(output: 'data/screenshot.png', width: 1024)
  puts "saving..."
end

#capture("http://fmi.ruby.bg")

def dl(url)
  now = Time.now
  response = Net::HTTP.get_response(URI(url))
  File.write("dl#{url.gsub(/http:|\/|\\|\./, '')}#{now.strftime('%Y%m%d%H%M%S%L')}", response.body)
end

dl("http://www.credoweb.bg/robots.txt")
