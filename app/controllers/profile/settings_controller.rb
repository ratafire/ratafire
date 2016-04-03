class Profile::SettingsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user

	#profile_settings_user_profile_settings GET
	def profile_settings
		tags_rotation('profile_settings')
	end

	#social_media_settings_user_profile_settings GET
	def social_media_settings
		tags_rotation('social_media_settings')
	end

	#language_settings_user_profile_settings GET
	def language_settings
		tags_rotation('language_settings')
	end

	#account_settings_user_profile_settings GET
	def account_settings
		tags_rotation('account_settings')
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:user_id])
	end	

	def tags_rotation(tag_name)
		@profile_settings_active_tag = ""
		@social_media_settings_active_tag = ""
		@account_settings_active_tag = ""
		case tag_name
		when "profile_settings"
			@profile_settings_active_tag = "active"
		when "social_media_settings"
			@social_media_settings_active_tag = "active"
		when "language_settings"
			@language_settings_active_tag = "active"
		when "account_settings"
			@account_settings_active_tag = "active"
		end
	end

end