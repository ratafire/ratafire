class Userinfo::ProfilephotosController < ApplicationController

	protect_from_forgery :except => [:update]

	#Before filters
	before_filter :load_user, only: [:create]
	before_filter :load_profilephoto, only: [:update,:destroy, :update_profilephoto]

	#REST Methods -----------------------------------
	
	#user_userinfo_profilephotos POST
	#/users/:user_id/userinfo/profilephotos	
	def create
	end

	#userinfo_profilephoto PATCH
	#/userinfo/profilephotos/:id(.:format)
	def update
		@profilephoto.direct_upload_url = params[:profilephoto][:direct_upload_url]
		@profilephoto.set_upload_attributes
		@profilephoto.update(profilephoto_params)
		if @profilephoto.transfer_and_cleanup
			@user_update_profilephoto = true
		else
			flash[:error] = "Unable to update profile photo."
		end
	end

	#userinfo_profilephoto DELETE
	#/userinfo/profilephotos/:id(.:format)
	def destroy
	end

	#NoREST Methods -----------------------------------

protected

	def profilephoto_params
		params.require(:profilephoto).permit(:image, :direct_upload_url, :user_uid)
	end	

	def load_user
		@user = User.find(params[:user_id])
	end

	def load_profilephoto
		@profilephoto = Profilephoto.find_by_uuid(params[:id])
	end

end