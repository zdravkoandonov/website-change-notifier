require 'yaml'

db_options = YAML.load(File.read('./config/database.yml'))
ActiveRecord::Base.establish_connection(db_options)

APP_DIRECTORY = '/home/zdravkoandonov/Source/Repos/website-change-notifier'.freeze
