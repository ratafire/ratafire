require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'i18n/backend/fallbacks'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ratafire3
	class Application < Rails::Application    
		config.active_record.raise_in_transactional_callbacks = true
		#Do not include all helpers
		config.action_controller.include_all_helpers = false
		#include lib files
		config.autoload_paths << Rails.root.join('lib')
		#Fall back for localization
		config.i18n.fallbacks = true
	end
end
