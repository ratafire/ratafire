class Profile::UserController < ApplicationController
#This controller controls functions related to homepage

	layout 'profile'

	def profile
		@user = User.find_by_username(params[:username])
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @user, owner_type: "User", trackable_type: ["Majorpost"]).page(params[:page]).per(5)
	end

end