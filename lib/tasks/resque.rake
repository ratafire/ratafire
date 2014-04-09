require "resque/tasks"
require 'resque_scheduler/tasks'
Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }
task "resque:setup" => :environment
