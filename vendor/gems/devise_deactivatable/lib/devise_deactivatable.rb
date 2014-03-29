require 'devise'

# TODO: there has to be a better way to do this
I18n.load_path += Dir.glob( File.dirname(__FILE__) + "/../config/locales/*.{rb,yml}" )

Devise.add_module :deactivatable, :model => 'devise_deactivatable/model'
