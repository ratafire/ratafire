class Studio::CampaignsController < ApplicationController

	layout :resolve_layout

	#Before filters
	before_filter :load_user
	before_filter :load_campaign, only:[:art,:update, :campaign_video,:campaign_video_image,:remove_campaign_video]
	before_filter :load_info, except:[:new, :create, :update,:apply]

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
	end

	#update_user_studio_campaigns GET
	#/users/:user_id/studio/campaigns/:campaign_id/update
	def update
		if @campaign.update(campaign_params)
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
		@campaign.rewards.create(
			user_id: @campaign.user_id
			)
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
		params.require(:campaign).permit(:user_id, :category, :title, :description, :sub_category, :tag_list, :country, :duration, :ratafirer)
	end

	def video_params
		params.require(:video).permit(:user_id,:video_uuid, :direct_upload_url, :campaign_id, :external)
	end	

	def video_image_params
		params.require(:video_image).permit(:user_id,:video_uuid,:image, :direct_upload_url, :campaign_id)
	end	

end