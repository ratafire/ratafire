AmazonFlexPay.access_key = ENV['AMAZON_KEY']
AmazonFlexPay.secret_key = ENV['AMAZON_SECRET']
AmazonFlexPay.go_live! if Rails.env.production?