require 'require_all'

require 'sinatra'
require 'rack/rewrite'

use Rack::Rewrite do
  r301 %r{^(.*[^/])$},  '$1/'
end

require_all 'models'
require_all 'routes'
