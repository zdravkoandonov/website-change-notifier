require_relative 'spec_helper'

describe LogItem do
  describe '#save' do
    let(:log_name) { 'testspec' }
    let(:log_file) { "#{APP_DIRECTORY}/logs/#{log_name}.log" }

    after(:each) do
      File.delete(log_file)
    end

    it 'saves the log message to the appropriate file' do
      message = 'This is a test message'
      LogItem.new(log_name, message).save
      saved_message = File.read(log_file)
      expect(message + "\n").to eq saved_message
    end

    it 'saves two log messages to the appropriate file on separate lines' do
      message1 = 'This is a test message1'
      message2 = 'This is a test message2'
      LogItem.new(log_name, message1).save
      LogItem.new(log_name, message2).save
      saved_message = File.read(log_file)
      expect(message1 + "\n" + message2 + "\n").to eq saved_message
    end
  end
end
