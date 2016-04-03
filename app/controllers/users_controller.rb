class UsersController < ActionController::Base

	#Before filters
	before_filter :load_user, only: [:update]

	#REST Methods -----------------------------------

	#user PATCH
	def update
		if @user.update(user_params)
			#flash["success"] = "Info updated."
			@error = false
		else
			#flash["error"] = @user.errors.full_messages.to_sentence
			@error = true
		end
	end

	#NoREST Methods -----------------------------------

	#user_disconnect GET
	def disconnect
		@provider = params[:provider]
		I18n.locale = current_user.locale
		case params[:provider]
		when "facebook"
			social_media = current_user.facebook
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.facebook'
		when "twitter"
			social_media = current_user.twitter
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.twitter'
		when "youtube"
			social_media = current_user.youtube
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.youtube'
		when "twitch"
			social_media = current_user.twitch
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.twitch'
		when "vimeo"
			social_media = current_user.vimeo
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.vimeo'
		when "soundcloud"
			social_media = current_user.soundcloud
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.soundcloud'
		when "tumblr"
			social_media = current_user.tumblr
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.tumblr'
		when "pinterest"
			social_media = current_user.pinterest
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.pinterest' 
		when "github"
			social_media = current_user.github
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.github'
		when "deviantart"
			social_media = current_user.deviantart
			@provider_title = I18n.t 'views.profile.settings.social_media_settings.deviantart' 
		when "paypal"
			social_media = current_user.paypal_account
			@provider_title = "PayPal"
			@paypal_user = '173'
		end
		social_media.destroy
	end

protected

	def load_user
		@user = User.find_by_uid(params[:id])
	end

	def user_params
		params.require(:user).permit(:tagline, :firstname, :lastname, :preferred_name, :bio, :country, :city, :locale, :website)
	end	

end