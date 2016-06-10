class Studio::CampaignsController < ApplicationController

	layout :resolve_layout

	#Before filters
	before_filter :load_user
	before_filter :load_campaign, only:[:art,:update, :campaign_video,:campaign_video_image,:remove_campaign_video, :remove_campaign_image,:post_update, :submit_application]
	before_filter :load_info, except:[:new, :create, :update,:apply]
	before_filter :currency, only:[:update]

	#After filter
	after_filter :create_reward, only:[:create]

	#REST Methods -----------------------------------

	#new_user_studio_campaigns GET      
	#/users/:user_id/studio/campaigns/new
	def new
		@campaign = Campaign.new()
	end

	#user_studio_campaigns POST
	#/users/:user_id/studio/campaigns
	def create
		if @campaign = @user.campaigns.create(campaign_params)
			redirect_to_application
		end
	end

	#NoREST Methods -----------------------------------

	#art_user_studio_campaigns GET
	#/users/:user_id/studio/campaigns/:campaign_id/art
	def art
		@upload_url = @upload_url = '/content/artworks/medium_editor_upload_artwork_campaign/'+@campaign.uuid
	end

	#update_user_studio_campaigns GET
	#/users/:user_id/studio/campaigns/:campaign_id/update
	def update
		#Build date object
		params[:campaign][:rewards_attributes].values.each do |reward|
			reward[:due] = DateTime.new(reward[:due].split('/')[2].to_i, reward[:due].split('/')[0].to_i, reward[:due].split('/')[1].to_i)
			reward[:estimated_delivery] = DateTime.new(reward[:estimated_delivery].split('/')[2].to_i, reward[:estimated_delivery].split('/')[0].to_i, reward[:estimated_delivery].split('/')[1].to_i)
		end
		#Update Rewards
		@campaign.rewards.first.update(
			goal_title: params[:campaign][:rewards_attributes].values.first[:goal_title],
			due: params[:campaign][:rewards_attributes].values.first[:due], 
			title: params[:campaign][:rewards_attributes].values.first[:title], 
			amount: params[:campaign][:rewards_attributes].values.first[:amount], 
			description: params[:campaign][:rewards_attributes].values.first[:description], 
			shipping: params[:campaign][:rewards_attributes].values.first[:shipping],
			estimated_delivery: params[:campaign][:rewards_attributes].values.first[:estimated_delivery]
			)			
		#Update Shipping countries
		if params[:campaign][:rewards_attributes].values.first[:shippings_attributes]
			params[:campaign][:rewards_attributes].values.first[:shippings_attributes].values.each do |shipping|
				if shipping[:_destroy] == "false" 		
					if sp = Shipping.find_by_reward_id_and_country(@campaign.rewards.first.id,shipping[:country])
						sp.update(
							amount: shipping[:amount],
							country: shipping[:country]
						)
					else
						Shipping.create(
							user_id: @user.id,
							campaign_id: @campaign.id,
							reward_id: @campaign.rewards.first.id,
							amount: shipping[:amount],
							country: shipping[:country]
						)
					end
				else
					if sp = Shipping.find_by_reward_id_and_country(@campaign.rewards.first.id,shipping[:country])
						sp.destroy
					end
				end
			end 
		end
		if @campaign.rewards.first.shippings.count == 0
			params[:campaign][:rewards_attributes].values.first[:shipping] == 'anywhere'
		end
		#Update Shipping shipping anywhere
		if params[:campaign][:rewards_attributes].values.first[:shipping_anywhere_attributes]
			if params[:campaign][:rewards_attributes].values.first[:shipping_anywhere_attributes][:_destroy] == "false"
				if @campaign.rewards.first.shipping_anywhere 
					unless @campaign.rewards.first.shipping_anywhere.amount == params[:campaign][:rewards_attributes].values.first[:shipping_anywhere_attributes][:amount]
						@campaign.rewards.first.shipping_anywhere.update(
							amount: params[:campaign][:rewards_attributes].values.first[:shipping_anywhere_attributes][:amount]
						)
					end
				else
					ShippingAnywhere.create(
						user_id: @user.id,
						campaign_id: @campaign.id,
						reward_id: @campaign.rewards.first.id,
						amount: params[:campaign][:rewards_attributes].values.first[:shipping_anywhere_attributes][:amount]
					)
				end
			else
				if @campaign.rewards.first.shipping_anywhere
					@campaign.rewards.first.shipping_anywhere.destroy
				end
			end
		else
			if @campaign.rewards.first.shipping_anywhere 
				@campaign.rewards.first.shipping_anywhere.destroy
				if params[:campaign][:rewards_attributes].values.first[:shipping] == 'anywhere'
					params[:campaign][:rewards_attributes].values.first[:shipping] = 'no'
				end
			else
				params[:campaign][:rewards_attributes].values.first[:shipping] = 'no'
			end
		end
		@campaign.update(campaign_params)
	end

	#update_user_studio_campaigns PATCH
	#/users/:user_id/studio/campaigns/:campaign_id/update
	def post_update
		respond_to do |format|
			if @campaign.update(fetch_campaign_params)
				format.js
			end
		end		
	end	

	#apply_user_studio_campaigns GET	
	#/users/:user_id/studio/campaigns/:campaign_id/apply
	def apply
		if @campaign = Campaign.find(params[:campaign_id])
			if @campaign.try(:published)
			else
				redirect_to_application
			end
		end
	end

	#campaign_video_user_studio_campaigns POST
	#/users/:user_id/studio/campaigns/:campaign_id/campaign_video
	def campaign_video
		@video = current_user.video.create(video_params)
		@video.encode!
	end

	#campaign_video_image_user_studio_campaigns POST
	#/users/:user_id/studio/campaigns/:campaign_id/campaign_video_image
	def campaign_video_image
		@video_image = current_user.video_image.create(video_image_params)
		@campaign.image = @video_image.image
		@campaign.save
	end

	#remove_campaign_video_user_studio_campaigns DELETE
	#/users/:user_id/studio/campaigns/:campaign_id/remove_campaign_video
	def remove_campaign_video
		if @video = @campaign.video
			@video.destroy
		end
	end

	#remove_campaign_image_user_studio_campaigns DELETE
	#/users/:user_id/studio/campaigns/:campaign_id/emove_campaign_image
	def remove_campaign_image
		@campaign.image.destroy
		@campaign.save
	end

	#submit_application_user_studio_campaigns PATCH
	#/users/:user_id/studio/campaigns/:campaign_id/submit_application
	def submit_application
		if @campaign.validate_status!
			#Update campaign status
			@campaign.update(
				status: "Pending"
			)
		else
			#render error messages
		end
	end

protected

	def load_info
		@alipay_user_en = '800'
		@paypal_user_en = '173'
		@alipay_user_zh = '8'
		@paypal_user_zh = '1.73'
	end

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_username(params[:user_id])
			unless @user = User.find_by_uid(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def load_campaign
		@campaign = Campaign.find(params[:campaign_id])
	end

	def create_reward
		if @campaign.rewards.count == 0 
			@campaign.rewards.create(
				user_id: @campaign.user_id
				)
		end
	end

	def currency
		case @campaign.country
		when 'AU'
			@campaign.currency = 'aud'
		when 'CA'
			@campaign.currency = 'cad'
		when 'DK'
			@campaign.currency = 'eur'
		when 'FI'
			@campaign.currency = 'eur'
		when 'IE'
			@campaign.currency = 'eur'
		when 'NO'
			@campaign.currency = 'eur'
		when 'SE'
			@campaign.currency = 'eur'
		when 'GB'
			@campaign.currency = 'eur'
		when 'US'
			@campaign.currency = 'usd'
		end
	end

	def redirect_to_application
		case @campaign.category
		when "Art"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		when "Music"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		when "Games"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		when "Writing"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		when "Videos"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		when "Math"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		when "Research: Science"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		when "Research: Humanity"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		when "Engineering"
			redirect_to art_user_studio_campaigns_path(@user.id, @campaign.id)
		end
	end

	def resolve_layout
		case action_name
		when "new","art"
		  "studio_fullwidth"
		else
		  "studio"
		end
	end

	def campaign_params
		params.require(:campaign).permit(:user_id, :category, :title, :description, :sub_category, :tag_list, :country, :currency, :duration, :ratafirer, :estimated_delivery,:_destroy, :content, :image, :status, :funding_type )
	end

	def fetch_campaign_params
		params.fetch(:campaign, {}).permit(:user_id, :category, :title, :description, :sub_category, :tag_list, :country, :currency, :duration, :ratafirer, :estimated_delivery,:_destroy, :image )
	end

	def video_params
		params.require(:video).permit(:user_id,:video_uuid, :direct_upload_url, :campaign_id, :external)
	end	

	def video_image_params
		params.require(:video_image).permit(:user_id,:video_uuid,:image, :direct_upload_url, :campaign_id)
	end	

end