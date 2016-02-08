module Updater
  def download_content(page_id)
    page = Page.find(page_id)

    now = Time.now
    response = Net::HTTP.get_response(URI(page.url))

    File.write("download/#{page.id}-#{now.strftime('%Y%m%d%H%M%S%L')}", response.body)

    page.last_updated = now
    page.save
  rescue Exception => exception
    # log exception
  end
end
