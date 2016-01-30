class Profile::UsercardController < ApplicationController
#This controller controls functions related to homepage

	def usercard
		@usercard_user = User.find_by_uid(params[:uid])
		render :layout => nil
	end

end