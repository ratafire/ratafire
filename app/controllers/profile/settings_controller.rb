class Profile::SettingsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user
	before_filter :show_followed
	
	#profile_settings_user_profile_settings GET
	#/users/:user_id/profile/settings/profile_settings
	def profile_settings
	end

	#social_media_settings_user_profile_settings GET
	#/users/:user_id/profile/settings/social_media_settings
	def social_media_settings
	end

	#language_settings_user_profile_settings GET
	#/users/:user_id/profile/settings/language_settings
	def language_settings
	end

	#account_settings_user_profile_settings GET
	#/users/:user_id/profile/settings/account_settings
	def account_settings
	end

	#notification_settings_user_profile_settings GET
	#/users/:user_id/profile/settings/notification_settings
	def notification_settings
	end

	#identity_verification_user_profile_settings GET
	#/users/:user_id/profile/settings/identity_verification
	def identity_verification
		@identity_verification = IdentityVerification.new
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:user_id])
	end	

	def show_followed
		if user_signed_in?
			@followed = current_user.likeds.order("last_seen desc").page(params[:followed_update]).per_page(3)
		end
	end

end