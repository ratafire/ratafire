class PlainPagesController < ApplicationController
	layout "plain"

	def profile_photo
		@user = User.find(params[:id])
	end

end
