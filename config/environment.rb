# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ratafire::Application.initialize!

#Initialize config
require 'aws/s3'

