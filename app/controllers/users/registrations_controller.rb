class Users::RegistrationsController < Devise::RegistrationsController

	layout 'profile'

	protect_from_forgery :except => [:update]

	#Before filters
	before_filter :load_user, only:[:update]

	#REST Methods -----------------------------------

	#content_user PATCH
	def update
		if current_user.update(user_params)
			#Different types of updating user
			if params[:user][:profilephoto]
				@user_update_profilephoto = true #Update profile photo
			end	
			#Response		
            respond_to do |format|
                format.html { render :nothing => true, :status => 200 }
                format.js
            end
		else
			flash[:error] = "Unable to update user"
		end		
	end

	#NoREST Methods -----------------------------------
	def after_update_path_for(resource)
	    render :nothing => true
	end

private

	def user_params
		params.require(:user).permit(:profilephoto)
	end	

	def load_user
		@user = User.find_by_username(params[:id])
	end

end