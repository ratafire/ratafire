class Admin::CampaignsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user, only:[:show]
	before_filter :load_campaign, only: [:review, :approve, :disapprove]

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
		@campaign.update(
			status: "Approved",
			published: true,
			published_at: Time.now,
			due: @campaign.duration.years.from_now
		)
		@campaign.rewards.last.update(
			active: true
		)
		redirect_to user_admin_campaigns_path(current_user.id)
		#Send email
		Studio::CampaignsMailer.review(@campaign.id).deliver_now
		#Create notification
		Notification.create(
			user_id: @campaign.user.id,
			trackable_id: @campaign.id,
			trackable_type: "Campaign",
			notification_type: "project_approved"
		)
	end

	#disapprove_admin_campaigns GET
	#/admin/campaigns/disapprove/:campaign_id
	def disapprove
		@campaign.update(
			status: "Disapprove"
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

end