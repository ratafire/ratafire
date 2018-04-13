class Admin::CampaignsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user, only:[:show]
	before_filter :load_campaign, only: [:review, :approve, :disapprove]
	before_filter :is_admin?	

	#REST Methods -----------------------------------

	#index_admin_campaigns GET
	#/admin/camapigns/index
	def index
		respond_to do |format|
			format.html
			format.json { render json: CampaignsDatatable.new(view_context) }
		end
	end	

	#user_admin_campaigns POST
	#/users/:user_id/admin/campaigns
	def show
	end

	#NoREST Methods -----------------------------------	

	#review_admin_campaigns GET
	#/admin/campaigns/review/:campaign_id
	def review
		@user = @campaign.user
	end

	#approve_admin_campaigns GET
	#/admin/campaigns/approve/:campaign_id
	def approve
		if @campaign.update(
			review_status: "Approved",
			reviewed: true,
			reviewed_at: Time.now
		)
			if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@campaign.id,'Campaign')
				@activity.update(
					published: true,
					status: "Approved"
				)
			end
			#Add search
			Resque.enqueue(Search::ChangeIndex, 'campaign',@campaign.id,'create')			
		end
		redirect_to user_admin_campaigns_path(current_user.id)
		#Send email
		#Studio::CampaignsMailer.review(@campaign.id).deliver_now
	end

	#disapprove_admin_campaigns GET
	#/admin/campaigns/disapprove/:campaign_id
	def disapprove
		@campaign.update(
			status: "Disapprove",
			review_status: nil,
			published: nil,
			published_at: nil
		)
		@campaign.user.update(
			creator: nil,
			creator_at: nil
		)			
		@campaign.rewards.last.update(
			active: nil
		)			
		redirect_to user_admin_campaigns_path(current_user.id)
		#Send email
		Studio::CampaignsMailer.review(@campaign.id).deliver_now
		#Create notification
		Notification.create(
			user_id: @campaign.user.id,
			trackable_id: @campaign.id,
			trackable_type: "Campaign",
			notification_type: "project_declined"
		)
	end	

	#hide_admin_campaigns GET
	#/admin/campaigns/hide/:campaign_id	
	def hide
		if @campaign.update(
			review_status: "Hide",
			reviewed: true,
			reviewed_at: Time.now
		)
			if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@campaign.id,'Campaign')
				@activity.update(
					published: true,
					status: "Hide",
					test: true
				)
			end		
		end
		redirect_to user_admin_campaigns_path(current_user.id)
		#Send email
		#Studio::CampaignsMailer.review(@campaign.id).deliver_now
	end

private

	def load_campaign
		@campaign = Campaign.find(params[:campaign_id])
	end

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def is_admin?
		if current_user.admin != true
			redirect_to root_path
		end
	end	

end