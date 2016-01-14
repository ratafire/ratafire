class Profile::UserController < ApplicationController
#This controller controls functions related to homepage

	layout 'profile'

	def profile
		@user = User.find_by_username(params[:username])
	end

end