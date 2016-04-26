class StaticPages::HomeController < ApplicationController
#This controller controls functions related to homepage

	layout 'static_pages'

	def home
		if current_user
			redirect_to profile_url_path(current_user.username)
		else
			render :action => 'home'
		end
	end

end