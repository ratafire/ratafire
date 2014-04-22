require "resque/tasks"
require 'resque_scheduler/tasks'
Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }
task "resque:setup" => :environment do
  Resque.after_fork do |job|
    ActiveRecord::Base.establish_connection
  end
end
