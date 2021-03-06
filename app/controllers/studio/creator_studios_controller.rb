class Studio::CreatorStudiosController < ApplicationController

	layout 'studio'

	#Before filters
	before_filter :authenticate_user!
	before_filter :load_user
	before_filter :correct_user

	#dashboard_user_studio_creator_studio GET
	#/users/:user_id/studio/creator_studio/dashboard
	def dashboard
	end

	#campaigns_user_studio_creator_studio GET
	#/users/:user_id/studio/creator_studio/campaigns
	def campaigns
		@popoverclass = SecureRandom.hex(16)
		@campaigns = @user.campaigns.where(:deleted => nil).page(params[:page]).per_page(8)
	end	

	#rewards_user_studio_creator_studio GET
	#/users/:user_id/studio/creator_studio/rewards
	def rewards
		@popoverclass = SecureRandom.hex(16)
		@rewards = @user.rewards.where(:deleted => nil).page(params[:page]).per_page(8)
	end	

	#current_goal_user_studio_creator_studio GET
	#/users/:user_id/studio/creator_studio/current_goal
	def current_goal
		@rewards = @user.rewards.where(:deleted => nil).page(params[:page]).per_page(9)
	end

	#notifications_user_studio_creator_studio GET
	#/users/:user_id/studio/creator_studio/notifications
	def notifications
		@notifications = @user.notifications.page(params[:page]).per_page(5)
		@notifications.each do |notification|
			if notification.is_read == false
				notification.update(
					is_read: true
					)
			end
		end
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:user_id])
	end	

	def correct_user
		if current_user != @user 
			if @user.admin
			else
				redirect_to root_path
			end
		else
			
		end
	end

end