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

	#language_settings_user_profile_settings GET
	def language_settings
	end

	#account_settings_user_profile_settings GET
	def account_settings
	end

	#identity_verification_user_profile_settings GET
	def identity_verification
		@identity_verification = IdentityVerification.new
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:user_id])
	end	

end