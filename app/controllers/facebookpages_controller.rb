
class FacebookpagesController < ApplicationController

	VERIFY_TOKEN = "mannersmakethman"

	def sync
		@facebookpage = Facebookpage.find_by_page_id(params[:page_id])
		if @facebookpage == nil then
			@facebookpage = Facebookpage.create_facebookpage(params[:page_id],params[:user_id])
			@facebook_page = FacebookPage.find_by_page_id(@facebookpage.page_id)
			if @facebook_page != nil then
				@facebookpage.facebook_page_id = @facebook_page.id
				@facebookpage.save
			end
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
			@facebook_page = FacebookPage.find_by_page_id(@facebookpage.page_id)
			if @facebook_page != nil then
				@facebookpage.facebook_page_id = @facebook_page.id
				@facebookpage.save
			end			
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

	def mask
		@facebookpage = Facebookpage.find_by_page_id(params[:page_id])
		@user = User.find(params[:user_id])
		@facebookpage.masked = true
		@facebookpage.memorized_fullname = @user.fullname
		@facebookpage.save
		@user.memorized_fullname = @user.fullname
		@user.fullname = @facebookpage.name
		@user.masked = true
		@user.save		
		flash[:message] = "You are now using your Facebook fan page's name as displayed name."
		redirect_to(:back)		
	end

	def unmask
		@facebookpage = Facebookpage.find_by_page_id(params[:page_id])
		@user = User.find(params[:user_id])
		@user.memorized_fullname = nil
		@user.fullname = @facebookpage.memorized_fullname
		@user.masked = nil
		@user.save
		@facebookpage.masked = nil
		@facebookpage.memorized_fullname = nil
		@facebookpage.save				
		flash[:message] = "You are now using your full name as your display name."
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