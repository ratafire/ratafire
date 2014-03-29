class ActivitiesController < ApplicationController
  #not in use
  	def destroy
		PublicActivity::Activity.find(params[:id]).destroy
		flash[:success] = "Activity hided."
		redirect_to(:back)
	end

end
