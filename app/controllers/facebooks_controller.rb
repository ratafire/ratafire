class FacebooksController < ApplicationController

	layout 'application_clean'	

	def facebook_signup
		@user = User.find_by_uuid(params[:uuid])
	end

end