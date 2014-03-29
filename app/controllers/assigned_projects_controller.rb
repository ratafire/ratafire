class AssignedProjectsController < ApplicationController

	def show
	end

	def new
	end

	def create

	end

	def update

	end

	def destroy
		AssignedProject.find(params[:id]).destroy
		flash[:success] = "User left project."
		redirect_to(:back)
	end

end