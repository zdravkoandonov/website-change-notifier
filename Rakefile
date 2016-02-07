namespace :db do
  desc "migrate the database"
  task :migrate do
    require 'bundler'
    Bundler.require
    require './config/environment'
    ActiveRecord::Migrator.migrate('db/migrate')
  end
end

task :spec do
  system 'rspec spec/login_spec.rb --color --format documentation'
end
