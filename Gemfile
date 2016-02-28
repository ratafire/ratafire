source 'https://rubygems.org'
ruby "2.2.0"
#------------------------ User ------------------------
#Signups and sessions
gem 'devise'

#Social Media
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-deviantart'
gem 'omniauth-twitch'
gem 'omniauth-tumblr'
gem 'omniauth-pinterest'
gem 'omniauth-soundcloud', :git => "git://github.com/ratafire/omniauth-soundcloud"
gem "omniauth-google-oauth2"
gem 'omniauth-vimeo', :git => "git://github.com/ratafire/omniauth-vimeo"
gem 'omniauth-facebookpages', :git => 'git://github.com/ratafire/omniauth-facebookpages'
gem 'omniauth-facebookposts', :git => 'git://github.com/ratafire/omniauth-facebookposts'
gem 'omniauth-paypal', :git => "git://github.com/ratafire/omniauth-paypal"
gem 'open_uri_redirections' #To get Facebook image
gem "koala", "~> 2.0" #To get Facebook realtime update

#------------------------ Main ------------------------
# Database
gem 'pg'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'turbolinks', '~> 5.0.0.beta'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Redirections
gem 'rack-reverse-proxy', :require => 'rack/reverse_proxy'
gem 'rack-rewrite'
# Show application.yml
gem "figaro"

#------------------------ UI ------------------------

gem 'autoprefixer-rails'
#Use jquery as the JavaScript library
gem 'jquery-rails'

#------------------------ Background Jobs ------------------------
#Redis
gem 'redis', '3.2.1' #For running Resque
#Resque
gem 'resque', '1.25.2',:require => "resque/server" #for background tasks, important
gem 'resque-scheduler'#For scheduled workers
gem 'resque_mailer' #For mailing in resque

#------------------------ Content ------------------------

#------------Updates------------
#Activity feed
gem 'public_activity', :path => 'vendor/gems/public_activity' # models/activity.rb acts_as_taggable_on :liker

#------------Url Redirections------------
gem 'friendly_id'

#------------Forms and Validation------------
#Ajax form entering
gem 'best_in_place', '~> 3.0.1'
#Validation
gem 'formvalidation-rails'

#------------File Upload System------------
#Amazon S3
gem 'aws-sdk', '< 2.0'
gem 'aws-s3'

#File upload handler
gem 'paperclip'
gem 's3_direct_upload', github: "ratafire/s3_direct_upload"
gem 'delayed_paperclip', :git => "git://github.com/jrgifford/delayed_paperclip.git"
gem 'mini_magick','3.7.0' #important
gem 'jquery-fileupload-rails', :path => "vendor/gems/jquery-fileupload-rails-master"
gem 'paperclip-ghostscript' #pdf

#Ajax File upload

#------------Video------------
#Video Interface
#gem 'videojs_rails',:git => "git://github.com/ratafire/videojs_rails.git"
#Video Encoder
gem 'httparty' #for Zencoder
gem 'zencoder-fetcher' #only for development

#------------Audio------------
#Get soundcloud id
gem "soundcloud"

#------------Tags------------
#Tag adder
gem 'acts-as-taggable-on', '~> 3.4' #important

#------------Paginate------------
#Paginator
gem 'will_paginate'
gem 'jquery-infinite-pages'

#------------Text Editor------------
#Text sanitizer
gem 'rails-html-sanitizer'

#------------Rating System------------
#Rating enabler
gem 'letsrate', :path => "vendor/gems/ratyrate"
gem 'acts_as_votable', '~> 0.10.0'

#------------Flash Message------------
gem 'unobtrusive_flash'

#------------Grab meta info from link------------
gem 'metainspector'
#------------Location------------
gem 'country_select'

#------------------------ Search ------------------------

#------------------------ Mailer ------------------------
#Outside mailing service
gem 'sendgrid'

#------------------------ Message System ------------------------
#Messaging
gem 'mailboxer'

#------------------------ Payments System ------------------------

#Stripe
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

#Paypal
gem 'paypal-sdk-rest'
gem 'paypal-sdk-merchant'
gem 'paypal-express', :git => 'https://github.com/ratafire/paypal-express'


#------------------------ Utilities ------------------------
#Browser differentiator
gem "browser"
#Autolink parser
gem "rinku"
#Enable maintainance
gem 'turnout'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

