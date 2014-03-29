class BetaUsersController < ApplicationController
	
	layout 'application'

	def new
		@user = BetaUser.new
	end

	def create
		@beta_user = BetaUser.new(params[:beta_user])
		if @beta_user.save
			flash[:success] = "You have submitted your beta application! We will inform you if you are selected as a beta user."
			redirect_to '/discovered'
		else
			redirect_to :back
		end
	end
end