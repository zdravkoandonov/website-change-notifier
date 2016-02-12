require 'bundler'
Bundler.require

require './config/environment'

require 'sidekiq/api'
require 'net/smtp'

# TODO: use cookie secret to invalidate crafted cookies
enable :sessions

use Rack::Rewrite do
  r301 %r{^(.+)/$}, '$1'
end

use Rack::MethodOverride

require_all 'lib'

require './helpers/membership'
helpers Membership

require_all 'models'
require_all 'routes'

require_all 'workers'
Sidekiq::Queue.new.clear
Sidekiq::Queue.new('default').clear
Sidekiq::RetrySet.new.clear
Sidekiq::ScheduledSet.new.clear
Sidekiq::Stats.new.reset
Waker.perform_async
