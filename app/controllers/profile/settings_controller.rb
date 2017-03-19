class Profile::SettingsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :authenticate_user!	
	before_filter :load_user
	before_filter :correct_user	
	before_filter :show_followed
	before_filter :connect_to_stripe, only: [:identity_verification]
	
	#profile_settings_user_profile_settings GET
	#/users/:user_id/profile/settings/profile_settings
	def profile_settings
	end

	#streaming_settings_user_profile_settings GET
	#/users/:user_id/profile/settings/streaming_settings
	def streaming_settings
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
		if @stripe_account = StripeAccount.find_by_user_id(@user.id)
			begin
				@account = Stripe::Account.retrieve(@stripe_account.stripe_id)
				#Sent out account status 
				case @account.legal_entity.verification.status
					when 'verified'
						@account_status = I18n.t('views.creator_studio.transfer.verified')
					when 'unverified'
						@account_status = I18n.t('views.creator_studio.transfer.unverified')
					when 'pending' 
						@account_status = I18n.t('views.creator_studio.transfer.pending')
				end
			rescue
			end
		end
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

	def connect_to_stripe
		if Rails.env.production?
			Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		else
			Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
		end
	end		

	def correct_user
		if current_user != @user 
			if @user.admin
			else
				redirect_to root_path
			end
		else
			
		end
	end

end