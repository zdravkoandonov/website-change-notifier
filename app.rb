require 'bundler'
Bundler.require

require './config/environment'

# TODO: use cookie secret to invalidate crafted cookies
enable :sessions

use Rack::Rewrite do
  r301 %r{^(.*[^/])$},  '$1/'
end

require_all 'models'
require_all 'routes'
