class FacebookupdatesController < ApplicationController

	def delete
		@facebookupdate = Facebookupdate.find(params[:id])
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@facebookupdate.id,'Facebookupdate')
		if @activity != nil then
			@activity.deleted = true
			@activity.deleted_at = Time.now
			@activity.save			
		end
		@facebookupdate.deleted = true
		@facebookupdate.deleted_at = Time.now
		@facebookupdate.save
		flash[:success] = "Update thrown away, and you hit a pine nut."
		redirect_to(:back)	
	end

end