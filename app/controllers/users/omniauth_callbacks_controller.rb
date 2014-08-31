class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		if current_user != nil
			#When the user exist
			@user = current_user
			facebook = Facebook.find_for_facebook_oauth(request.env['omniauth.auth'], @user.id)
			if facebook.persisted?
				flash[:success] = "Connected to Facebook."
				redirect_to(:back)
			else
				flash[:success] = "Fail to connect to Facebook."
				redirect_to(:back)
			end
		else
			#When the user doesn't exist
			@user = User.new
			@user.uuid = SecureRandom.hex(16)
			@user.save(:validate => false)
			facebook = Facebook.facebook_signup_oauth(request.env['omniauth.auth'], @user.id) 
			if facebook != false then
				if User.find_by_username(facebook.username) == nil then
					@user.update_column(:fullname,facebook.name)
					@user.update_column(:email,facebook.email)
					@user.update_column(:username,facebook.username)
				else
					@user.update_column(:fullname,facebook.name)
					@user.update_column(:email,facebook.email)					
				end				
				redirect_to facebook_signup_path(@user.uuid)	
				Resque.enqueue_at(10.minutes.from_now, AbortedFacebookSignupWorker, :user_id => @user.id)	
			else
				redirect_to new_user_registration_path
				flash[:success] = "User exists."
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

end