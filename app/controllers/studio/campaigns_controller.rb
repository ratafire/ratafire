class Studio::CampaignsController < ApplicationController

	layout :resolve_layout

	#Before filters
	before_filter :load_user
	before_filter :load_campaign, only:[:edit, :application,:update, :campaign_video,:campaign_video_image,:remove_campaign_video, :remove_campaign_image,:post_update, :submit_application, :display_read_all, :upload_image, :upload_image_edit, :update_content_edit, :update_content_cancel, :mark_as_completed, :abandon, :completed, :delete]
	before_filter :load_info, except:[:new, :create, :update,:apply]
	before_filter :currency, only:[:update]
	before_filter :only_confirmed
    #Check who is responsible for the versioning
    #before_filter :set_paper_trail_whodunnit #problematic

	#After filter
	after_filter :create_reward, only:[:create]

	#REST Methods -----------------------------------

	# new_user_studio_campaigns GET      
	#/users/:user_id/studio/campaigns/new
	def new
		@campaign = Campaign.new()
	end

	# user_studio_campaigns POST
	#/users/:user_id/studio/campaigns
	def create
		if @campaign = @user.campaigns.create(campaign_params)
			if @campaign.category
				@campaign.category_list = @campaign.category
				@campaign.save
			end
			redirect_to_application
		end
	end

	# edit_user_studio_campaigns GET
	#/users/:user_id/studio/campaigns/:campaign_id/edit
	def edit
		
	end

	#NoREST Methods -----------------------------------

	#application_user_studio_campaigns GET
	#/users/:user_id/studio/campaigns/:campaign_id/application
	def application
		@upload_url = '/content/artworks/medium_editor_upload_artwork_campaign/'+@campaign.uuid
	end

	#update_user_studio_campaigns GET
	#/users/:user_id/studio/campaigns/:campaign_id/update
	def update
		#Build date object
		if params[:campaign][:rewards_attributes]
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
				goal: params[:campaign][:rewards_attributes].values.first[:goal],
				description: params[:campaign][:rewards_attributes].values.first[:description], 
				shipping: params[:campaign][:rewards_attributes].values.first[:shipping],
				estimated_delivery: params[:campaign][:rewards_attributes].values.first[:estimated_delivery],
				currency: @campaign.currency
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
					if @campaign.rewards.first.shippings.count == 0
						params[:campaign][:rewards_attributes].values.first[:shipping] = 'no'
					end
				end
			end
		end
		@campaign.update(campaign_params)
		#Update activity
		update_campaign_activity
		if @campaign.sub_category
			@campaign.sub_category_list = @campaign.sub_category
			@campaign.save
		end
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
				if @campaign.try(:abandoned) || @campaign.try(:completed)
					redirect_to new_user_studio_campaigns_path(@user.username)
				else
					redirect_to(:back)
				end
			else
				redirect_to_application
			end
		end
	end

	#campaign_video_user_studio_campaigns POST
	#/users/:user_id/studio/campaigns/:campaign_id/campaign_video
	def campaign_video
		if @campaign.video
			@previous_video = @campaign.video
		end
		if @video = current_user.video.create(video_params)
			@video.encode!
			#Remove previous video
			if @previous_video
				@previous_video.update(
					deleted: true,
					deleted_at: Time.now
				)
			end
		end
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
				status: "Pending",
				applied_at: Time.now
			)
		else
			#render error messages
		end
	end

	#display_read_all_user_studio_campaigns GET
	#/users/:user_id/studio/campaigns/:campaign_id/display_read_all
	def display_read_all
	end

	#upload_image_user_studio_campaigns POST
	#/users/:user_id/studio/campaigns/:campaign_id/upload_image
	def upload_image
		@campaign.update(campaign_params)
		@campaign.set_upload_attributes
		@campaign.transfer_and_cleanup
	end

	#upload_image_edit_user_studio_campaigns GET
	def upload_image_edit
	end

	#update_content_edit_user_studio_campaigns GET
	def update_content_edit
		@upload_url = '/content/artworks/medium_editor_upload_artwork_campaign/'+@campaign.uuid
	end

	#update_content_cancel_user_studio_campaigns GET
	def update_content_cancel
	end

	#mark_as_completed_user_studio_campaigns POST
	def mark_as_completed
		@campaign.update(
			completed: true,
			completed_at: Time.now
		)
		#Mark activity as completed
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@campaign.id,'Campaign')
			@activity.update(
				completed: true
			)
		end
		#End all rewards
		@campaign.rewards.where(:deleted => nil, :ended_early => nil).all.each do |reward|
			reward.update(
				ended_early: true,
				ended_early_at: Time.now,
				active: false
			)
		end		
		#Add xp
		@campaign.user.add_score("quest_lg")			
		redirect_to completed_user_studio_campaigns_path(@user.id, @campaign.id)
	end

	#completed_user_studio_campaigns GET
	def completed
	end

	#abandon_user_studio_campaigns POST
	def abandon
		@campaign.update(
			abandoned: true,
			abandoned_at: Time.now
		)
		#Mark activity as abandoned
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@campaign.id,'Campaign')
			@activity.update(
				abandoned: true
			)
		end
		#End all rewards
		@campaign.rewards.where(:deleted => nil, :ended_early => nil).all.each do |reward|
			reward.update(
				ended_early: true,
				ended_early_at: Time.now,
				active: false
			)
		end
		flash['warning'] = I18n.t('views.campaign.you_abandoned_project') + @campaign.title
		redirect_to campaigns_user_studio_creator_studio_path(@user.username)
	end

	def delete
		#Delete campaign
		@campaign.rewards.all.each do |reward|
			reward.destroy
		end
		#Delete campaign
		@campaign.destroy
		redirect_to campaigns_user_studio_creator_studio_path(@user.username)
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
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
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
		@campaign.currency = 'usd'
		#case @campaign.country
		#when 'AU'
		#	@campaign.currency = 'aud'
		#when 'CA'
		#	@campaign.currency = 'cad'
		#when 'DK'
		#	@campaign.currency = 'eur'
		#when 'FI'
		#	@campaign.currency = 'eur'
		#when 'IE'
		#	@campaign.currency = 'eur'
		#when 'NO'
		#	@campaign.currency = 'eur'
		#when 'SE'
		#	@campaign.currency = 'eur'
		#when 'GB'
		#	@campaign.currency = 'eur'
		#when 'US'
		#	@campaign.currency = 'usd'
		#end
	end

	def redirect_to_application
		redirect_to application_user_studio_campaigns_path(@user.id, @campaign.id)
	end

	def resolve_layout
		case action_name
		when "new","application", "completed"
		  "studio_fullwidth"
		else
		  "studio"
		end
	end

	def campaign_params
		params.require(:campaign).permit(:user_id, :category, :title, :description, :sub_category, :tag_list, :country, :currency, :duration, :ratafirer, :estimated_delivery,:_destroy, :content, :image,:funding_type, :direct_upload_url, :content_updated_at )
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

	def only_confirmed
		unless @user.confirmed_at
			redirect_to(:back)
			flash[:error] = t('flash.user.email_not_confirmed')
		end
	end

	def update_campaign_activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@campaign.id,'Campaign')
			@activity.update(
				category: @campaign.category,
				sub_category: @campaign.sub_category,
				published: @campaign.published,
				tag_list: @campaign.tag_list
			)
		end
	end

end