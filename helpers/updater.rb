module Updater
  def download_content(page_id)
    page = Page.find(page_id)

    now = Time.now
    response = Net::HTTP.get_response(URI(page.url))

    File.write("download/#{page.id}-#{now.strftime('%Y%m%d%H%M%S%L')}", response.body)

    page.last_updated = now
    page.save

    open('logs/downloads.log', 'a') do |f|
      f.puts now.to_s + ' Downloaded ' + page.url
    end
  rescue Exception => exception
    open('logs/downloads.log', 'a') do |f|
      f.puts now.to_s + ' ' + exception.to_s
    end
  end
end
