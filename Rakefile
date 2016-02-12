namespace :db do
  desc "migrate the database"
  task :migrate do
    require 'bundler'
    Bundler.require
    require './config/environment'
    require_all 'models'
    ActiveRecord::Migrator.migrate('db/migrate')
  end
end

task :spec do
  system 'rspec --color --format documentation'
end
