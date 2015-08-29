class CollectiblesController < ApplicationController

  before_filter :signed_in_user
  before_filter :correct_user

	def manage_collectibles
		@user = User.find(params[:id])
		@projects = @user.projects.where(:published => true, :complete => false, :abandoned => false)
		@facebookpages = @user.facebookpages.where(:sync => true)
	end

	def update_facebookpage_collectibles
		@facebookpage = Facebookpage.find(params[:facebookpage_id])
		@user = User.find(params[:id])
		if params[:facebookpage][:collectible] != @facebookpage.collectible then
			collectible = Collectible.prefill!(:user_id => @user.id, :facebookpage_id => @facebookpage.id, :level => 10, :content => params[:facebookpage][:collectible])
		end
		if params[:facebookpage][:collectible_20] != @facebookpage.collectible_20 then
			collectible = Collectible.prefill!(:user_id => @user.id, :facebookpage_id => @facebookpage.id, :level => 20, :content => params[:facebookpage][:collectible_20])
		end		
		if params[:facebookpage][:collectible_50] != @facebookpage.collectible_50 then
			collectible = Collectible.prefill!(:user_id => @user.id, :facebookpage_id => @facebookpage.id, :level => 50, :content => params[:facebookpage][:collectible_50])
		end			
		if params[:facebookpage][:collectible_100] != @facebookpage.collectible_100 then
			collectible = Collectible.prefill!(:user_id => @user.id, :facebookpage_id => @facebookpage.id, :level => 100, :content => params[:facebookpage][:collectible_100])
		end		
		if params[:facebookpage][:collectible] == nil || params[:facebookpage][:collectible] == "" then
			flash["error"] = "Collectible for $10 can't be blank."
			redirect_to(:back)
		else
			if @facebookpage.update_attributes(params[:facebookpage]) then
				flash["success"] = 'Facebook fan page collectibles updated!'
				redirect_to(:back)
			end			
		end
	end

private	

	def signed_in_user
	  unless signed_in?
		redirect_to new_user_session_path, notice:"Please sign in." unless signed_in?
	  end
	end

	def current_user?(user)
	  user == current_user
	end

	def correct_user
	  @user = User.find(params[:id])
	  redirect_to(root_url) unless current_user?(@user)
	end


end