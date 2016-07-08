class Studio::RewardsController < ApplicationController

	#Before filters
	before_filter :load_user
	before_filter :load_reward, only:[:upload_image, :remove_image]

	#REST Methods -----------------------------------

	#new_user_studio_rewards GET      
	#/users/:user_id/studio/rewards/new
	def new
	end

	#user_studio_rewards POST
	#/users/:user_id/studio/rewards
	def create
	end

	#NoREST Methods -----------------------------------

	#upload_image_user_studio_rewards GET
	#/users/:user_id/studio/campaigns/:reward_id/update
	def upload_image
		@reward.update(reward_params)
		@reward.set_upload_attributes
		@reward.transfer_and_cleanup
	end

	#remove_image_user_studio_rewards DELETE
	#/users/:user_id/studio/campaigns/:reward_id/update
	def remove_image
		@reward.image.destroy
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def load_reward
		@reward = Reward.find(params[:reward_id])
	end

	def reward_params
		params.require(:reward).permit(:goal_title, :due, :title, :amount, :backers, :description, :shipping, :_destroy, :estimated_deliver, :image, :direct_upload_url)
	end

end