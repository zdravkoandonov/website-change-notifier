apt-get install sqlite3
apt-get install libsqlite3-dev

if ! bundle ; then
	apt-get install bundler && gem install bundler && bundle
fi

#
# now change the app home directory in config/environment.rb
#

rake db:migrate

apt-get install redis-server

mkdir logs
touch sidekiq.log sinatra.log redis.log

redis-server &>logs/sidekiq.log &

# Install nginx + unicorn ##################
# https://www.digitalocean.com/community/tutorials/how-to-deploy-sinatra-based-ruby-web-applications-on-ubuntu-13

apt-get install nginx

gem install unicorn

# # unicorn.rb
# Place the below block of code, modifying it as necessary:

# # Set the working application directory
# # working_directory "/path/to/your/app"
# working_directory "/var/www/my_app"

# # Unicorn PID file location
# # pid "/path/to/pids/unicorn.pid"
# pid "/var/www/my_app/pids/unicorn.pid"

# # Path to logs
# # stderr_path "/path/to/logs/unicorn.log"
# # stdout_path "/path/to/logs/unicorn.log"
# stderr_path "/var/www/my_app/logs/unicorn.log"
# stdout_path "/var/www/my_app/logs/unicorn.log"

# # Unicorn socket
# # listen "/tmp/unicorn.[app name].sock"
# listen "/tmp/unicorn.myapp.sock"

# # Number of processes
# # worker_processes 4
# worker_processes 2

# # Time-out
# timeout 30

# And a config.ru:

require './app'
run Sinatra::Application

############################################

mkdir download

sidekiq -r ./app.rb &>logs/sidekiq.log &

ruby app.rb &>logs/sinatra.log &