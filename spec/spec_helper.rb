require_relative '../app'

require 'capybara/rspec'

Capybara.app = Sinatra::Application.new
