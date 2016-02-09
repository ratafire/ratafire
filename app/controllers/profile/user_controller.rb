class Profile::UserController < ApplicationController
#This controller controls functions related to homepage

	layout 'profile'

	#Before filters
	before_filter :load_user, only:[:profile]

	protect_from_forgery :except => [:update_profile]

	def profile
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @user, owner_type: "User", :published => true,trackable_type: ["Majorpost"]).page(params[:page]).per_page(5)
		@popoverclass = SecureRandom.hex(16)
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:username])
	end	

	def user_params
		params.require(:user).permit(:profilephoto)
	end		

end