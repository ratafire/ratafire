OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['249146721904203'], ENV['7314060e069b3db3977fdc5de2a12fa1'],
   :display => 'popup'
end