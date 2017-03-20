class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	require "open-uri"

	before_filter :load_user, except: [:facebook]

	#Facebook
	def facebook
		#Params :signup :login
		params = request.env["omniauth.params"]
		#Sign up with Facebook
		if params["login"] == "true"
			if user_signed_in?
				redirect_to(:back)
			else
				#When the user isn't signed in
				if facebook = Facebook.find_by_uid(request.env['omniauth.auth'].uid)
					if @user = facebook.user
						sign_in(:user, @user)
						redirect_to root_path
					else
						redirect_to(:back)
					end
				else
					redirect_to(:back)
				end
			end
		end
		#Sign up with Facebook
		if params["signup"] == "true"
			if user_signed_in?
				redirect_to(:back)
			else
				if facebook = Facebook.find_by_uid(request.env['omniauth.auth'].uid)
					if @user = facebook.user
						sign_in(:user, @user)
						redirect_to root_path
					else
						redirect_to(:back)
					end
				else
					#When the user doesn't exist
					if @user = User.find_by_email(request.env['omniauth.auth'].info.email)
						if @user.invitation_token
						else
							redirect_to(:back)
						end
					else
						@user = User.new
					end
			        begin
			            uid = SecureRandom.hex(16)
			        end while User.find_by_uid(uid).present?
			        @user.uid = uid
					@user.skip_confirmation!
					@user.save(:validate => false)
					if Facebook.facebook_signup_oauth(request.env['omniauth.auth'], @user.id)
						if @facebook = Facebook.find_by_uid(request.env['omniauth.auth'].uid)
						  	@profilephoto = Profilephoto.create(
						  		user_id: @user.id,
						  		user_uid: @user.uid,
						  		skip_everafter: true
						  	)
						  	@profilecover = Profilecover.create(
						  		user_id: @user.id,
						  		user_uid: @user.uid,
						  		skip_everafter: true
						  	)		
						  	@user.skip_confirmation!
						  	@user.update_column(:email, @facebook.email)
						  	@user.update_column(:fullname, @facebook.name)
						  	@user.update(
						  		confirmed_at: Time.now,
						  		firstname: @facebook.first_name,
						  		lastname: @facebook.last_name,
						  		preferred_name: @facebook.name
						  	)
						  	if @user.fullname
						  		split = @user.fullname.split(' ', 2)
						  		@user.firstname = split.first
						  		@user.lastname = split.last
						  	end
						  	@user.skip_confirmation!
						  	@user.save(:validate => false)
							#Add extra info
							if @facebook.bio != nil then 
								@user.update_column(:bio,@facebook.bio.truncate(210))
							else
								if @facebook.school != nil then
									if @facebook.concentration != nil then
										bio = @facebook.concentration + ", "+@facebook.school
										@user.update_column(:bio,bio.truncate(210))
									else
										bio = @facebook.school
										@user.update_column(:bio,bio.truncate(210))
									end
								end
							end
							if @facebook.locale != nil then
								@user.update_column(:location,@facebook.locale)
							end
							if @facebook.concentration != nil then
								@user.update_column(:tagline, @facebook.concentration.truncate(42))
							else
								if @facebook.school != nil then
									@user.update_column(:tagline, @facebook.school.truncate(42))
								end
							end
							if @facebook.website != nil then
								@user.update_column(:website, @facebook.website.truncate(100))
							end
							#Avatar
							if @facebook.image != nil then 
								@profilephoto.image_from_url(@facebook.image)
								@profilephoto.save
							end
						end
						#Add search
						Resque.enqueue(Search::ChangeIndex, 'user',@user.id,'create')
						#Sign in and redirect
						sign_in(@user, scope: :user)
						redirect_to profile_url_path(@user.username)	
					else
						#Destroy the user
						@user.destroy
						redirect_to new_user_registration_path
					end
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

	def user_params
		params.require(:user).permit(:username, :email, :uid, :fullname, :firstname, :lastname)
	end

	def facebook_params
		params.require(:facebook).permit(:uid, :name, :image, :first_name, :last_name, :link, :first_name, :last_name, :link, :username, :gener, :locale, :user_birthday, :bio, :website)
	end
	

end