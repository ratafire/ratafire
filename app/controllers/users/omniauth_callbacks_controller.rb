class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	require "open-uri"

	before_filter :load_user, except: [:facebook]

	#Facebook
	def facebook
		#Params :signup :login
		params = request.env["omniauth.params"]
		#Sign up with Facebook
		if params["signup"] == "true"
			if user_signed_in?
				redirect_to(:back)
			else
				#When the user isn't signed in
				if facebook = Facebook.find_by_uid(request.env['omniauth.auth'].uid)
					if @user = facebook.user
						sign_in(:user, @user)
						redirect_to(:back)
					else
						redirect_to new_user_session_path
					end
				else
					redirect_to new_user_session_path
				end
			end
		end
		#Sign in with Facebook
		if params["login"] == "true"
			if user_signed_in?
				redirect_to(:back)
			else
				#When the user doesn't exist
				@user = User.new
				@user.save(:validate => false)
				if facebook = Facebook.facebook_signup_oauth(request.env['omniauth.auth'], @user.id)
					@user.update_column(
						fullname: facebook.name,
						email: facebook.email,
						confirmed_at: Time.now
						)
					#Add extra info
					if facebook.bio != nil then 
						@user.update_column(:bio,facebook.bio.truncate(210))
					else
						if facebook.school != nil then
							if facebook.concentration != nil then
								bio = facebook.concentration + ", "+facebook.school
								@user.update_column(:bio,bio.truncate(210))
							else
								bio = facebook.school
								@user.update_column(:bio,bio.truncate(210))
							end
						end
					end
					if facebook.locale != nil then
						@user.update_column(:location,facebook.locale)
					end
					if facebook.concentration != nil then
						@user.update_column(:tagline, facebook.concentration.truncate(42))
					else
						if facebook.school != nil then
							@user.update_column(:tagline, facebook.school.truncate(42))
						end
					end
					if facebook.website != nil then
						@user.update_column(:website, facebook.website.truncate(100))
					end
					#Avatar
					if facebook.image != nil then 
						@user.profilephoto.image_from_url(facebook.image)
						@user.profilephoto.save
					end
					#Sign in and redirect
					sign_in(:user, @user)
					redirect_to(:back)
				else
					#Destroy the user
					@user.destroy
					redirect_to(:back)
				end
			end
		end
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