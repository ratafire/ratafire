
class FacebookpagesController < ApplicationController

	VERIFY_TOKEN = "mannersmakethman"

	def sync
		@facebookpage = Facebookpage.find_by_page_id(params[:page_id])
		if @facebookpage == nil then
			@facebookpage = Facebookpage.create_facebookpage(params[:page_id],params[:user_id])
			if @facebookpage != nil  then
				#subscribe to facebook update
				subscribe_to_facebook_update
			else
				if @facebookpage != nil then 
					#subscribe to facebook update
					subscribe_to_facebook_update
				else
					flash[:message] = "Facebook page sync failed."
					redirect_to(:back)				
				end
			end
		else
			@facebookpage = Facebookpage.update_facebookpage(params[:page_id],params[:user_id])
			if @facebookpage != nil then
				#subscribe to facebook update
				subscribe_to_facebook_update
			else
				if @facebookpage != nil then 
					#subscribe to facebook update
					subscribe_to_facebook_update
				else
					flash[:message] = "Facebook page sync failed."
					redirect_to(:back)				
				end
			end
		end	
	end

	def unsync
		@facebookpage = Facebookpage.find_by_page_id(params[:page_id])
		@facebookpage.update_column(:sync,false)
		@facebook_page = FacebookPage.find_by_page_id(params[:page_id])
		@facebook_page.update_column(:sync,false)
		flash[:message] = "Facebook page unsynced."
		redirect_to(:back)
	end

private
	

	def subscribe_to_facebook_update
		if Rails.env.production? then
			#updates = Koala::Facebook::RealtimeUpdates.new(:app_id => ENV['FACEBOOK_KEY'], :secret => ENV['FACEBOOK_SECRET'])
			#response = updates.subscribe("user","feed","https://www.ratafire.com/facebook_update_callback_kingsman", VERIFY_TOKEN)
			Resque.enqueue(FacebookupdateAllWorker, params[:page_id])	
			#Insert verification
			flash[:message] = "Facebook page synced."
			redirect_to(:back)				
		else
			Resque.enqueue(FacebookupdateAllWorker, params[:page_id])	
			flash[:message] = "Facebook page synced."
			redirect_to(:back)				
		end
	end

end