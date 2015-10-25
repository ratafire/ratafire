# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::ReverseProxy do
  reverse_proxy /^\/blog(\/.*)$/, 'http://ratafire.flywheelsites.com$1', :username => 'flywheel', :password => 'skynettie', :timeout => 500, :preserve_host => true
end

run Ratafire::Application
