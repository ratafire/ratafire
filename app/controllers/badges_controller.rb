class BadgesController < ApplicationController

	def show
		@user = User.find(params[:id])
	end

	def download
	  	send_file(
			"#{Rails.root}/public/downloads/RatafireLogoKit.zip",
	    	filename: "RatafireLogoKit.zip",
	    	type: "application/zip"
	  	)
	end

end