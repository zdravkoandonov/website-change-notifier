require_relative 'spec_helper'

describe DiffMessage do
  describe '#to_s' do
    let(:url) { 'http://fmi.ruby.bg/' }
    let(:time_string) { Time.now.to_s }
    let(:email_address) { 'test@test.asd' }

    it 'generates an email message if the platform is :email' do
      message = DiffMessage.new(url, time_string, :email, email_address).to_s
      expected_message = "From: zdravkoandonov.com notifier <notifier@zdravkoandonov.com>\n" +
        "To: <#{email_address}>\n" +
          "Subject: Change detected at #{url} - #{time_string}\n" +
            "There is a change detected at #{url}."
      expect(message).to eq expected_message
    end

    it 'generates a simple message if the platform is other than :email' do
      message = DiffMessage.new(url, time_string, :slack).to_s
      expected_message = "#{time_string}: There is a change detected at #{url}."
      expect(message).to eq expected_message
    end
  end
end
