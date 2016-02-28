class Userinfo::ProfilecoversController < ApplicationController

	protect_from_forgery :except => [:update]

	#Before filters
	before_filter :load_user, only: [:create]
	before_filter :load_profilecover, only: [:update,:destroy, :update_profilecover]

	#REST Methods -----------------------------------
	
	#user_userinfo_profilecovers POST
	#/users/:user_id/userinfo/profilecovers	
	def create
	end

	#userinfo_profilecover PATCH
	#/userinfo/profilecovers/:id(.:format)
	def update
		@profilecover.direct_upload_url = params[:profilecover][:direct_upload_url]
		@profilecover.set_upload_attributes
		@profilecover.update(profilecover_params)
		if @profilecover.transfer_and_cleanup
			@user_update_profilecover = true
		else
			flash[:error] = "Unable to update profile photo."
		end
	end

	#userinfo_profilecover DELETE
	#/userinfo/profilecovers/:id(.:format)
	def destroy
	end

	#NoREST Methods -----------------------------------

protected

	def profilecover_params
		params.require(:profilecover).permit(:image, :direct_upload_url)
	end	

	def load_user
		@user = User.find(params[:user_id])
	end

	def load_profilecover
		@profilecover = Profilecover.find_by_uuid(params[:id])
	end

end
