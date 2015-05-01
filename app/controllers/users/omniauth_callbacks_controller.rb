class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	require "open-uri"

	def facebook
		params = request.env["omniauth.params"]
		if params["subscribed_id"] == nil then
			#Facebook Signup
			if current_user != nil
				#When the user exist
				@user = current_user
				facebook = Facebook.find_for_facebook_oauth(request.env['omniauth.auth'], @user.id)
				if facebook.persisted?
					flash[:success] = "Connected to Facebook."
					#Add Facebook to profile photo if profile photo is nil
					unless @user.profilephoto.exists? then
						avatar_url = @user.process_uri(facebook.image)
						@user.update_attribute(:profilephoto, URI.parse(avatar_url))
					end
					#Add extra info
					if @user.bio == nil || @user.bio == "" then
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
					end
					if @user.location == nil || @user.location == "" then
						if facebook.locale != nil then
							@user.update_column(:location,facebook.locale)
						end
					end
					if @user.tagline == nil || @user.tagline == "" then
						if facebook.concentration != nil then
							@user.update_column(:tagline, facebook.concentration.truncate(42))
						else
							if facebook.school != nil then
								@user.update_column(:tagline, facebook.school.truncate(42))
							end
						end
					end
					if @user.website == nil || @user.website == "" then
						if facebook.website != nil then
							@user.update_column(:website, facebook.website.truncate(100))
						end
					end			
					if params["after_signup"] == nil then			
						redirect_to edit_user_path(@user)
					else
						@user.tutorial.facebook = true
						@user.tutorial.save
						redirect_to user_path(@user)
					end
				else
					flash[:success] = "Fail to connect to Facebook."
					if params["after_signup"] == nil then			
						redirect_to edit_user_path(@user)
					else
						redirect_to user_path(@user)
					end
				end
			else
				#When the user doesn't exist
				@user = User.new
				@user.uuid = SecureRandom.hex(16)
				@user.save(:validate => false)
				facebook = Facebook.facebook_signup_oauth(request.env['omniauth.auth'], @user.id) 
				if facebook != false then
					if facebook.username != nil then
						facebook_username_clearned = facebook.username.gsub!('.', '_')
					end
					if User.find_by_username(facebook_username_clearned) == nil then
						@user.update_column(:fullname,facebook.name)
						@user.update_column(:email,facebook.email)
						@user.update_column(:username,facebook_username_clearned)
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
					else
						@user.update_column(:fullname,facebook.name)
						@user.update_column(:email,facebook.email)	
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
					end				
					redirect_to facebook_signup_path(@user.uuid)	
					avatar_url = @user.process_uri(facebook.image)
					@user.update_attribute(:profilephoto, URI.parse(avatar_url))		
					Resque.enqueue_at(10.minutes.from_now, AbortedFacebookSignupWorker, @user.id)	
				else
					redirect_to new_user_registration_path
					flash[:success] = "User exists."
				end	
			end
		else
			if current_user == nil
				#New User
				@user = User.new
				@user.uuid = SecureRandom.hex(16)
				@user.save(:validate => false)
				@user.tutorial.intro = true
				@user.tutorial.save
				facebook = Facebook.facebook_signup_oauth(request.env['omniauth.auth'], @user.id) 
				if facebook != false then
					if facebook.username != nil then
						@facebook_username_clearned = facebook.username.gsub!('.', '_')
					end
					if User.find_by_username(@facebook_username_clearned) == nil then
						@user.update_column(:fullname,facebook.name)
						@user.update_column(:email,facebook.email)
						@user.update_column(:username,@facebook_username_clearned)	
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
					else
						@user.update_column(:fullname,facebook.name)
						@user.update_column(:email,facebook.email)	
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
						if @facebook_username_clearned != nil then
							@user.username = loop do 
								token = @facebook_username_clearned+SecureRandom.hex(4)
								break token unless User.exists?(username: token)
							end
							@user.need_username = true
							@user.save
						else
							@user.username = loop do 
								token = SecureRandom.hex(8)
								break token unless User.exists?(username: token)
							end
							@user.need_username = true
							@user.save	
						end								
					end
					unless @user.profilephoto.exists? then
						avatar_url = @user.process_uri(facebook.image)
						@user.update_attribute(:profilephoto, URI.parse(avatar_url))
					end		
					sign_in(:user, @user)
					redirect_to subscribe_path(params["subscribed_id"],params["subscription_type"],params["amount"])						
				else
					if request.env['omniauth.auth'] != false then
						#Try to login user
						@user = User.find_by_email(request.env['omniauth.auth'].info.email)
						facebook = Facebook.find_for_facebook_oauth(request.env['omniauth.auth'], @user.id)
						if facebook.persisted? then
							unless @user.profilephoto.exists? then
								avatar_url = @user.process_uri(facebook.image)
								@user.update_attribute(:profilephoto, URI.parse(avatar_url))
							end						
							#Login user
							sign_in(:user, @user)
							#Redirect
							redirect_to subscribe_path(params["subscribed_id"],params["subscription_type"],params["amount"])
						else
							flash[:error] = "Facebook authorization failed."
							redirect_to(:back)
						end
					else
						flash[:error] = "Facebook authorization failed."
						redirect_to(:back)
					end
				end
			else
				@user = current_user
				facebook = Facebook.find_for_facebook_oauth(request.env['omniauth.auth'], @user.id)
				if facebook.persisted?
					#Add Facebook to profile photo if profile photo is nil
					unless @user.profilephoto.exists? then
						avatar_url = @user.process_uri(facebook.image)
						@user.update_attribute(:profilephoto, URI.parse(avatar_url))
					end
					#Add Facebook to profile photo if profile photo is nil
					unless @user.profilephoto.exists? then
						avatar_url = @user.process_uri(facebook.image)
						@user.update_attribute(:profilephoto, URI.parse(avatar_url))
					end
					#Add extra info
					if @user.bio == nil || @user.bio == "" then
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
					end
					if @user.location == nil || @user.location == "" then
						if facebook.locale != nil then
							@user.update_column(:location,facebook.locale)
						end
					end
					if @user.tagline == nil || @user.tagline == "" then
						if facebook.concentration != nil then
							@user.update_column(:tagline, facebook.concentration.truncate(42))
						else
							if facebook.school != nil then
								@user.update_column(:tagline, facebook.school.truncate(42))
							end
						end
					end
					if @user.website == nil || @user.website == "" then
						if facebook.website != nil then
							@user.update_column(:website, facebook.website.truncate(100))
						end
					end							
					redirect_to subscribe_path(params["subscribed_id"],params["subscription_type"],params["amount"])
				else
					flash[:success] = "Facebook authorization failed."
					redirect_to(:back)
				end			
			end			
		end
	end

	def twitter
		@user = current_user
		twitter = Twitter.find_for_twitter_oauth(request.env['omniauth.auth'], @user.id)
		if twitter.persisted?
			flash[:success] = "Connected to Twitter."
			redirect_to edit_user_path(current_user)
		else
			flash[:success] = "Fail to connect to Twitter."
			redirect_to edit_user_path(current_user)
		end
	end

	def github
		@user = current_user
	#	render :text => request.env['omniauth.auth'].to_yaml
		github = Github.find_for_github_oauth(request.env['omniauth.auth'], @user.id)
		if github.persisted?
			flash[:success] = "Connected to Github."
			redirect_to(:back)
		else
			flash[:success] = "Fail to connect to Github."
			redirect_to(:back)
		end	
	end

	def deviantart
		@user = current_user
		deviantart = Deviantart.find_for_deviantart_oauth(request.env['omniauth.auth'], @user.id)
		if deviantart.persisted?
			flash[:success] = "Connected to Deviantart."
			redirect_to edit_user_path(current_user)
		else
			flash[:success] = "Fail to connect to Deviantart."
			redirect_to edit_user_path(current_user)
		end
	end

	def vimeo
		@user = current_user
		vimeo = Vimeo.find_for_vimeo_oauth(request.env['omniauth.auth'], @user.id)
		if vimeo.persisted?
			flash[:success] = "Connected to Vimeo."
			redirect_to edit_user_path(current_user)
		else
			flash[:success] = "Fail to connect to Vimeo."
			redirect_to edit_user_path(current_user)
		end
	end

	def venmo
		@user = current_user
		venmo = UserVenmo.find_for_venmo_oauth(request.env['omniauth.auth'], @user.id)
		params = request.env["omniauth.params"]
		if params["payment"] == "false" then
			#This is to add Venmo without payment
			if venmo.persisted?
				flash[:success] = "Connected to Venmo."
				redirect_to payment_settings_path(current_user)	
			else
				flash[:success] = "Fail to connect to Venmo."
				redirect_to payment_settings_path(current_user)		
			end
		else
			if venmo.persisted?
				subscriber_id = params["subscriber_id"]
				subscribed_id = params["subscribed_id"]
				amount = params["amount"]
				method = params["method"]
				redirect_to add_venmo_subscribe_path(subscriber_id,subscribed_id,amount)
			else
				flash[:success] = "Fail to connect to Venmo."
				redirect_to user_path(params["subscriber_id"])
			end
		end
	end

  	def failure
  		if current_user != nil then
  			current_user.tutorial.facebook = false
  			current_user.tutorial.save
  		end
    	redirect_to root_path 
  	end

end