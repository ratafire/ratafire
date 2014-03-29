class InvitedsController < ApplicationController

	def update
		@invited = Invited.find(params[:id])
		@project = @invited.project
		if @invited.update_attributes(params[:invited]) then
			@project.users.push(@invited.user)
			@project.save
			@invited.destroy
			redirect_to(:back)
			flash[:success] = "You joined #{@project.title}."
		end
	end

	def destroy
		@invited = Invited.find(params[:id])
		@invited.destroy
		redirect_to(:back)
		flash[:success] = "User removed from the invited list."
	end

end