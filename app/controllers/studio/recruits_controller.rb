class Studio::RecruitsController < ApplicationController

	layout 'studio'

	#Before filters
	before_filter :authenticate_user!, except: [:accept_invitation]
	before_filter :load_user
	before_filter :correct_user, except: [:accept_invitation]

	#REST Methods -----------------------------------

	# user_studio_recruits GET
	# /users/:user_id/studio/recruit
	def show
		@recruit = User.new
	end

	# user_studio_recruits POST
	# /users/:user_id/studio/recruit
	def create
		if User.find_by_email(params[:user][:email]) 
			redirect_to(:back)
			flash[:error] = t('errors.messages.taken')
		else
			User.invite!({:email => params[:user][:email]}, @user)
			redirect_to(:back)
		end
	end

	#noREST Methods -----------------------------------
	# accept_invitation_user_studio_recruits POST
	# /users/:user_id/studio/recruit/accept_invitation
	def accept_invitation
		if params[:user][:firstname] != nil && params[:user][:lastname] != nil && params[:user][:password] != nil && @user
	        begin
	            @user.uid = SecureRandom.hex(16)
	        end while User.find_by_uid(@user.uid).present?	
	        @user.skip_confirmation!
			if I18n.locale == :zh 
				@user.update(
					preferred_name: params[:user][:lastname] + params[:user][:firstname],
					fullname: params[:user][:lastname] + params[:user][:firstname],
					firstname: params[:user][:firstname],
					lastname: params[:user][:lastname],
					password: params[:user][:password],
					invitation_accepted_at: Time.now,
					invitation_token: nil,
					tagline: I18n.t('views.utilities.devise.default_tagline')
				)
			else
				@user.update(
					preferred_name: params[:user][:firstname]+ ' ' + params[:user][:lastname],
					fullname: params[:user][:firstname]+ ' ' + params[:user][:lastname],
					firstname: params[:user][:firstname],
					lastname: params[:user][:lastname],
					password: params[:user][:password],
					invitation_accepted_at: Time.now,
					invitation_token: nil,
					tagline: I18n.t('views.utilities.devise.default_tagline')
				)
			end
		  	Profilephoto.create(
		  		user_id: @user.id,
		  		user_uid: @user.uid,
		  		skip_everafter: true
		  	)
		  	Profilecover.create(
		  		user_id: @user.id,
		  		user_uid: @user.uid,
		  		skip_everafter: true
		  	)				
		  	@user.add_score("quest_sm")
		  	if @inviter = User.find(@user.invited_by_id)
		  		@inviter.add_score("quest")
		  	end
			sign_in(@user, scope: :user)
			redirect_to profile_url_path(@user.username)
		else
			redirect_to(:back)
		end
	end

	# recruited_datatable_user_studio_recruits GET
	# /users/:user_id/studio/recruit/recruited_datatable
	def recruited_datatable
		respond_to do |format|
			format.html
			format.json { render json: RecruitedDatatable.new(view_context) }
		end
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
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