require_relative 'spec_helper'

describe DiffMessage do
  describe '#to_s' do
    let(:url) { 'http://fmi.ruby.bg/' }
    let(:time_string) { Time.now.to_s }
    let(:email_address) { 'test@test.asd' }

    it 'generates an email message if an email address is provided' do
      message = DiffMessage.new(url, time_string, email_address).to_s
      expected_message = "From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>\n" +
        "To: <#{email_address}>\n" +
          "Subject: Change detected at #{url} - #{time_string}\n" +
            "There is a change detected at #{url}."
      expect(message).to eq expected_message
    end

    it 'generates a simple message if no email address is provided' do
      message = DiffMessage.new(url, time_string).to_s
      expected_message = "#{time_string}: There is a change detected at #{url}."
      expect(message).to eq expected_message
    end
  end
end
