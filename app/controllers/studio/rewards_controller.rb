class Studio::RewardsController < ApplicationController

	layout 'studio'

	#Before filters
	before_filter :authenticate_user!	
	before_filter :load_user
	before_filter :load_reward, only:[:upload_image, :remove_image, :show, :upload_reward_editor, :confirm_upload_reward, :upload_reward]
	before_filter :correct_user

	#REST Methods -----------------------------------

	#new_user_studio_rewards GET      
	#/users/:user_id/studio/rewards/new
	def new
		@reward = Reward.new()
	end

	#user_studio_rewards POST
	#/users/:user_id/studio/rewards
	def create
		if @campaign = @user.active_campaign
			#Build date object
			params[:reward][:due] = DateTime.new(params[:reward][:due].split('/')[2].to_i, params[:reward][:due].split('/')[0].to_i, params[:reward][:due].split('/')[1].to_i)
			params[:reward][:estimated_delivery] = DateTime.new(params[:reward][:estimated_delivery].split('/')[2].to_i, params[:reward][:estimated_delivery].split('/')[0].to_i, params[:reward][:estimated_delivery].split('/')[1].to_i)
			#Update Rewards
			@reward = Reward.new(reward_params)
			@reward.update(
				user_id: @user.id,
				campaign_id: @user.active_campaign.id
			)
			#Update Shipping countries
			if params[:reward][:shippings_attributes]
				params[:reward][:shippings_attributes].values.each do |shipping|
					if shipping[:_destroy] == "false" 		
						if sp = Shipping.find_by_reward_id_and_country(@reward.id,shipping[:country])
							sp.update(
								amount: shipping[:amount],
								country: shipping[:country]
							)
						else
							Shipping.create(
								user_id: @user.id,
								campaign_id: @campaign.id,
								reward_id: @reward.id,
								amount: shipping[:amount],
								country: shipping[:country]
							)
						end
					else
						if sp = Shipping.find_by_reward_id_and_country(@reward.id,shipping[:country])
							sp.destroy
						end
					end
				end 
			end
			if @reward.shippings.count == 0
				@reward.update(
					shipping: 'anywhere'
				)
			end
			#Update Shipping shipping anywhere
			if params[:reward][:shipping_anywhere_attributes]
				if params[:reward][:shipping_anywhere_attributes].values.first[:_destroy] == "false"
					if @reward.shipping_anywhere 
						unless @reward.shipping_anywhere.amount == params[:reward][:shipping_anywhere_attributes].values.first[:amount]
							@reward.shipping_anywhere.update(
								amount: params[:reward][:shipping_anywhere_attributes].values.first[:amount]
							)
						end
					else
						ShippingAnywhere.create(
							user_id: @user.id,
							campaign_id: @campaign.id,
							reward_id: @reward.id,
							amount: params[:reward][:shipping_anywhere_attributes].values.first[:amount]
						)
					end
				else
					if @reward.shipping_anywhere
						@reward.shipping_anywhere.destroy
					end
				end
			else
				if @reward.shipping_anywhere 
					@reward.shipping_anywhere.destroy
					if @reward.shipping == 'anywhere'
						@reward.update(
							shipping: 'no'
						)
					end
				else
					if @campaign.rewards.first.shippings.count == 0
						@reward.update(
							shipping: 'no'
						)
					end
				end
			end
		end
		redirect_to rewards_user_studio_creator_studio_path(@user.username)
	end

	#show_user_studio_rewards GET
	#/users/:user_id/studio/rewards/:reward_id
	def show
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

	#receiver_datatable_user_studio_rewards GET
	#/users/:user_id/studio/rewards/receiver_datatable/:reward_id
	def receiver_datable
		respond_to do |format|
			format.html
			format.json { render json: ReceiverDatatable.new(view_context) }
		end
	end

	#upload_image_edit_user_studio_rewards GET
	def upload_image_edit
	end

	#my_rewards_user_studio_rewards GET
	def my_rewards
	end

	#my_rewards_datatable_user_studio_rewards GET
	def my_rewards_datatable
		respond_to do |format|
			format.html
			format.json { render json: MyRewardsDatatable.new(view_context) }
		end		
	end

	#confirm_shipping_payment_user_studio_rewards GET
	#/users/:user_id/studio/rewards/confirm_shipping_payment/:shipping_order_id
	def confirm_shipping_payment
		@shipping_order = ShippingOrder.find(params[:shipping_order_id])
		@reward_receiver = RewardReceiver.find(@shipping_order.reward_receiver_id)
		if @shipping_order.transacted
			redirect_to(:back)
		end
		@reward = Reward.find(@shipping_order.reward_id)
	end

	#upload_reward_editor_user_studio_rewards GET
	#/users/:user_id/studio/rewards/upload_reward_editor/:reward_id
	def upload_reward_editor
	end

	#upload_reward_user_studio_rewards POST 
	#/users/:user_id/studio/rewards/upload_reward/:reward_id
	def upload_reward
		if @reward_upload = RewardUpload.find_by_reward_id(@reward.id)
			@reward_upload.update(reward_upload_params)
		else
			@reward_upload = RewardUpload.create(reward_upload_params)
		end
	end

	#confirm_upload_reward_user_studio_rewards POST
	#/users/:user_id/studio/rewards/confirm_upload_reward/:reward_id
	def confirm_upload_reward
		if @reward_upload = RewardUpload.find_by_reward_id(@reward.id)
			@reward.update(
				uploaded: true,
				uploaded_at: Time.now
			)
			#Resque change receivers to uploaded
			Resque.enqueue(Reward::DownloadReady, @reward.id)
			redirect_to(:back)
		else
			redirect_to(:back)
		end
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
		params.require(:reward).permit(:goal_title, :due, :title, :amount, :backers, :description, :shipping, :_destroy, :estimated_delivery, :image, :direct_upload_url)
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

	def reward_upload_params
		params.require(:reward_upload).permit(:user_id, :reward_id, :package, :direct_upload_url)
	end

end