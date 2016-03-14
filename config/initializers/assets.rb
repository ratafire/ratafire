# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( template_foundry.scss template_foundry.css template_foundry.js template_limitless.scss template_limitless.css template_limitless.js page_specific/profile_user.js page_specific/settings.js page_specific/creator_studio.js template_limitless_layouts/layout2.css template_limitless_layouts/layout3.css)