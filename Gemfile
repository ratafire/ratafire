source 'https://rubygems.org'

ruby "1.9.3" #Ruby 2.0 will cause S3 connection timeout, omg

gem 'redis', '3.0.7'
gem 'hiredis', '0.5.1'
gem 'em-synchrony', '1.0.3'
#gem 'redis-rails'

gem 'rake', '10.2.2'

#gem 'sidekiq' #for background tasks
gem 'resque', '1.25.2',:require => "resque/server" #for background tasks
gem 'resque-scheduler','2.5.5', :require => "resque_scheduler/server"

gem 'rails', '3.2.13'
gem 'jquery-rails', '3.0.4'

#User
gem 'devise', '3.2.4'
gem 'devise_invitable', '1.3.4' #rails cannot startup because of from /data/ratafire/releases/20140326193429/app/controllers/invitations_controller.rb:1

#Activity feed
gem 'public_activity', :path => 'vendor/gems/public_activity' # models/activity.rb acts_as_taggable_on :liker

#Url
gem 'friendly_id', '4.0.9' #important
gem 'mechanize' #get external title important

#Forms and Validation
gem 'client_side_validations', '3.2.6'#important
gem 'nested_form', '0.3.2'#important
gem 'best_in_place', :path => "vendor/gems/best_in_place-master" #important

#Video
gem 'aws-sdk','1.38.0' #S3
gem 'aws-s3', '0.6.3'#s3
gem 'videojs_rails', :git => "git://github.com/ratafire/videojs_rails.git"
gem 'httparty' #for Zencoder
gem 'zencoder-fetcher' #only for development
gem 'i18n', '0.6.1'

#Tags
gem 'acts-as-taggable-on', '2.4.1' #important 

#File Upload
gem 'paperclip', "3.5.4" #important
gem 'delayed_paperclip', :git => "git://github.com/jrgifford/delayed_paperclip.git"
gem 'carrierwave','0.10.0' #important
gem 'fog','1.21.0'
gem 'mini_magick','3.7.0' #important
gem 'jquery-fileupload-rails', :path => "vendor/gems/jquery-fileupload-rails-master" #important

#Paginate
gem 'will_paginate', '~> 3.0' #important

#Editor
gem 'redactor-rails', :git => "git://github.com/ratafire/redactor-rails.git" #important
gem 'mathjax-rails'

#Social Media
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-deviantart'
gem 'omniauth-vimeo', :git => "git://github.com/lomography/omniauth-vimeo"

#Sanitize
gem 'sanitize','2.1.0'

#Ajax
gem 'ajaxify_rails','0.9.5'

#Search
gem 'thinking-sphinx', '3.1.0'

#sql
gem 'mysql2'

#google 
gem 'google-analytics-rails'

#Amazon Payments
#gem "rest-client", :require => "rest_client"
#gem 'netrc' #rest-client dependency
gem 'amazon_flex_pay'#, :git => "git://github.com/ratafire/amazon_flex_pay.git" #changed for reacurring pipeline
gem "figaro" #configuration

#Pass value from controller to javascript
gem 'gon','5.0.4'

group :development do
	#gem 'sqlite3', '1.3.5'
	gem 'rspec-rails', '2.10.0' 
	gem 'guard-rspec' #For automatically running rspec
	gem 'annotate', '2.5.0' #For showing up database structure in schema
end

# Gems used only for assets and not required
# in production environments by default.

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
end

group :test do
	gem 'rspec-rails', '2.10.0'
	gem 'capybara', '1.1.2'
	gem 'rb-fsevent', :require => false
	gem 'growl', '1.0.3'
	gem 'factory_girl_rails', '1.4.0'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
