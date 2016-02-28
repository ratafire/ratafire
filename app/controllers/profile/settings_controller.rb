class Profile::SettingsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user

	#profile_settings_user_profile_settings GET
	def profile_settings
	end

	#social_media_settings_user_profile_settings GET
	def social_media_settings
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:user_id])
	end	

end