class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	require "open-uri"

	before_filter :load_user, except: [:facebook]

	#Facebook
	def facebook
	end

	#Twitter
	def twitter
		twitter = Twitter.find_for_twitter_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#YouTube
	def google_oauth2
		youtube = Youtube.find_for_youtube_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#Twitch
	def twitch
		twitch = Twitch.find_for_twitch_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#Vimeo
	def vimeo
		twitch = Vimeo.find_for_vimeo_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#SoundCloud
	def soundcloud
		soundcloud = SoundcloudOauth.find_for_soundcloud_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#Tumblr
	def tumblr
		tumblr = Tumblr.find_for_tumblr_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#Pinterest
	def pinterest
		pinterest = Pinterest.find_for_pinterest_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#Github
	def github
		github = Github.find_for_github_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#Deviantart
	def deviantart
		deviantart = Deviantart.find_for_deviantart_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to_settings
	end

	#PayPal
	def paypal
		params = request.env["omniauth.params"]
		paypal = PaypalAccount.find_for_paypal_oauth(request.env['omniauth.auth'], @user.id)
		redirect_to apply_user_studio_campaigns_path(@user.id, params["campaign_id"])
	end

private
	
	def load_user
		@user = current_user
	end

	def redirect_to_settings
		redirect_to social_media_settings_user_profile_settings_path(@user.username)
	end

end