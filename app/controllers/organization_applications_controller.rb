class OrganizationApplicationsController < ApplicationController

	before_filter :correct_user

	protect_from_forgery :except => [:organization_video_upload]

	def basic_info
		@user = User.find(params[:id])
		if @user.organization_application == nil then
			@organization_application = OrganizationApplication.create
			@organization_application.save(:validate => false)
			@organization_application.update_column(:user_id, @user.id)
		else
			@organization_application = @user.organization_application
		end
		if @organization_application.step == 1 then
			#redirect_to basic_info_organization_application_path(@user)
		else
			if @organization_application.step == 2 then
				redirect_to video_organization_application_path(@user, @organization_application)
			else
				if @organization_application.step == 3 then
					redirect_to payments_organization_application_path(@user,@organization_application)
				else
					if @organization_application.step == 4 then
						redirect_to pending_organization_application_path(@user)
					end
				end
			end
		end
	end

	def video
		@user = User.find(params[:id])
		@organization_application = @user.organization_application
		@video = @organization_application.video
		if @organization_application.step == 1 then
			redirect_to basic_info_organization_application_path(@user)
		else
			if @organization_application.step == 2 then
				#redirect_to video_organization_application_path(@user, @organization_application)
			else
				if @organization_application.step == 3 then
					redirect_to payments_organization_application_path(@user,@organization_application)
				else
					if @organization_application.step == 4 then
						redirect_to pending_organization_application_path(@user)
					end
				end
			end
		end		
	end

	def organization_video_upload
		@video = Video.new(params[:video])
		@video.user_id = params[:id]
		@user = User.find(params[:id])
		@video.organization_application_id = @user.organization_application.id
		@video.save
		#Redirect
	end

	def payments
		@user = User.find(params[:id])
		@organization_application = @user.organization_application
		if @organization_application.step == 1 then
			redirect_to basic_info_organization_application_path(@user)
		else
			if @organization_application.step == 2 then
				redirect_to video_organization_application_path(@user, @organization_application)
			else
				if @organization_application.step == 3 then
					#redirect_to payments_organization_application_path(@user,@organization_application)
				else
					if @organization_application.step == 4 then
						redirect_to pending_organization_application_path(@user)
					end
				end
			end
		end			
	end

	def updates
		@organization_application = OrganizationApplication.find(params[:organization_application_id])
		@user = User.find(@organization_application.user_id)
		@organization_application.update_attributes(params[:organization_application])
		application_redirect
	end

	def cancel
		@organization_application = OrganizationApplication.find(params[:organization_application_id])
		@user = User.find(@organization_application.user_id)
		#Destroy the icon
		if @organization_application.icon != nil then
			@organization_application.icon.clear
		end
		#Destroy the video
		if @organization_application.video != nil then
			@organization_application.video.destroy
		end
		@organization_application.destroy
		redirect_to user_path(@user)
	end

private

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

	def current_user?(user)
	  user == current_user
	end	


	def application_redirect
		if @organization_application.step == 1 then
			redirect_to basic_info_organization_application_path(@user)
		else
			if @organization_application.step == 2 then
				redirect_to video_organization_application_path(@user, @organization_application)
			else
				if @organization_application.step == 3 then
					redirect_to payments_organization_application_path(@user,@organization_application)
				else
					if @organization_application.step == 4 then
						redirect_to pending_organization_application_path(@user)
					end
				end
			end
		end
	end

end