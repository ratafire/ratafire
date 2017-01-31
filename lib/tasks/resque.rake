require "resque/tasks"
require 'resque/scheduler/tasks'
Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }
task "resque:preload" => :environment
task "resque:setup" => :environment do
	Resque.after_fork do |job|
  		Resque.redis.client.reconnect
    	ActiveRecord::Base.establish_connection
  	end
end