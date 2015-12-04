# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# use 'whenever -i' to apply

# set :output, "../cron_log.log"

# every :day, :at => '17:28 pm' do
#   command :task => "ruby capture.rb"
#   command :task => "ruby diff.rb"
# end

every '17 * * * *' do
  command "cd change-notifier/ && ruby ~/Source/Repos/website-change-notifier/change-notifier.rb"
end

