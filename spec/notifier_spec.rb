require_relative 'spec_helper'

describe Notifier do
    let(:url) { 'http://fmi.ruby.bg/' }
    let(:time) { Time.now.to_s }
    let(:email) { 'test@test.asd' }
    let(:message) { DiffMessage.new(url, time, email) }

    # TODO: find a way to send emails to a fake account
    # that the tests have access to

    # it 'logs before sending the email' do

    # end
end
