class Studio::CreatorStudiosController < ApplicationController

	layout 'studio'

	#Before filters
	before_filter :load_user

	#dashboard_user_studio_creator_studio GET
	#/users/:user_id/studio/creator_studio/dashboard
	def dashboard
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:user_id])
	end	

end