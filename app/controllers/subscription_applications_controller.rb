class SubscriptionApplicationsController < ApplicationController

	before_filter :correct_user

	def setup
		@user = User.find(params[:id])
		@subscription_progression = 14
		unless @user.subscription_application.any? then
			@subscription_application = SubscriptionApplication.new
			@subscription_application.user_id = @user.id
			@subscription_application.goals_subscribers = @user.goals_subscribers
			@subscription_application.goals_monthly = @user.goals_monthly
			@subscription_application.goals_project = @user.goals_project
			if @user.why != nil then 
				@subscription_application.why = @user.why
			end
			@subscription_application.save
		else
			@subscription_application = @user.subscription_application[0]
		end
		#Redirect
		if @subscription_application.step != nil then 
			if @subscription_application.step == 1 then #To Goals
				redirect_to goals_subscription_path(@user,@subscription_application)
			else
				if @subscription_application.step == 2 then #To Project
					redirect_to project_subscription_path(@user, @subscription_application)
				else
					if @subscription_application.step == 3 then #To Discussion
						redirect_to discussion_subscription_path(@user, @subscription_application)
					else
						if @subscription_application.step == 4 then #To Payments
							redirect_to payments_subscription_path(@user, @subscription_application)
						else
							if @subscription_application.step == 5 then #To Identification
								redirect_to identification_subscription_path(@user, @subscription_application)
							else
								if @subscription_application.step == 6 then #To Apply
									redirect_to apply_subscription_path(@user, @subscription_application)
								else 
									if @subscription_application.step == 7 then #To Review
										redirect_to pending_subscription_path(@user, @subscription_application)
									else
										
									end
								end
							end
						end
					end
				end
			end
		end
	end

	def updates
		@subscription_application = SubscriptionApplication.find(params[:subscription_application_id])
		@user = User.find(@subscription_application.user_id)
		@subscription_application.update_attributes(params[:subscription_application])
		application_redirect		
	end

	def goals
		@user = User.find(params[:id])
		@subscription_progression = 28
		@subscription_application = @user.subscription_application[0]
		if @user.plan != nil then
			@subscription_application.plan = @user.plan
			@subscription_application.save
		end
		if @subscription_application.why == nil then
			flash[:success] = "Please fill out 'To Subscribers'."
			@subscription_application.step = nil
			@subscription_application.save
			redirect_to setup_subscription_path(@user.id)
		end
		#Redirect
		if @subscription_application.step != 1 then 
			if @subscription_application.step == 1 then #To Goals
				#redirect_to goals_subscription_path(@user,@subscription_application)
			else
				if @subscription_application.step == 2 then #To Project
					redirect_to project_subscription_path(@user, @subscription_application)
				else
					if @subscription_application.step == 3 then #To Discussion
						redirect_to discussion_subscription_path(@user, @subscription_application)
					else
						if @subscription_application.step == 4 then #To Payments
							redirect_to payments_subscription_path(@user, @subscription_application)
						else
							if @subscription_application.step == 5 then #To Identification
								redirect_to identification_subscription_path(@user, @subscription_application)
							else
								if @subscription_application.step == 6 then #To Apply
									redirect_to apply_subscription_path(@user, @subscription_application)
								else 
									if @subscription_application.step == 7 then #To Review
										redirect_to pending_subscription_path(@user, @subscription_application)
									else
										
									end
								end
							end
						end
					end
				end
			end
		end
	end

	def project
		@user = User.find(params[:id])
		@subscription_progression = 42		
		@subscription_application = @user.subscription_application[0]
		@project = @user.projects.where(:published => true, :complete => false, :abandoned => false).first
		#Redirect
		if @subscription_application.plan == nil || @subscription_application.plan == "" then
			flash[:success] = "Please write an intended update frequency or plan."
			@subscription_application.step = 1
			@subscription_application.save
			redirect_to setup_subscription_path(@user.id)
		else
			if @subscription_application.step != 2 then 
				if @subscription_application.step == 1 then #To Goals
					redirect_to goals_subscription_path(@user,@subscription_application)
				else
					if @subscription_application.step == 2 then #To Project
						#redirect_to project_subscription_path(@user, @subscription_application)
					else
						if @subscription_application.step == 3 then #To Discussion
							redirect_to discussion_subscription_path(@user, @subscription_application)
						else
							if @subscription_application.step == 4 then #To Payments
								redirect_to payments_subscription_path(@user, @subscription_application)
							else
								if @subscription_application.step == 5 then #To Identification
									redirect_to identification_subscription_path(@user, @subscription_application)
								else
									if @subscription_application.step == 6 then #To Apply
										redirect_to apply_subscription_path(@user, @subscription_application)
									else 
										if @subscription_application.step == 7 then #To Review
											redirect_to pending_subscription_path(@user, @subscription_application)
										else
										
										end
									end
								end
							end
						end
					end
				end
			end			
		end		
	end

	def discussion
		@user = User.find(params[:id])
		@subscription_progression = 56
		@subscription_application = @user.subscription_application[0]
		@discussion = @user.discussions.where(:published => true, :review_status => "Approved", :deleted => false).first
		#Redirect
		if @subscription_application.collectible == nil || @subscription_application.collectible == "" then
			flash[:success] = "Please provide a collectible."
			@subscription_application.step = 2
			@subscription_application.save
			redirect_to setup_subscription_path(@user.id)
		else
			if @subscription_application.step != 3 then 
				if @subscription_application.step == 1 then #To Goals
					redirect_to goals_subscription_path(@user,@subscription_application)
				else
					if @subscription_application.step == 2 then #To Project
						redirect_to project_subscription_path(@user, @subscription_application)
					else
						if @subscription_application.step == 3 then #To Discussion
							#redirect_to discussion_subscription_path(@user, @subscription_application)
						else
							if @subscription_application.step == 4 then #To Payments
								redirect_to payments_subscription_path(@user, @subscription_application)
							else
								if @subscription_application.step == 5 then #To Identification
									redirect_to identification_subscription_path(@user, @subscription_application)
								else
									if @subscription_application.step == 6 then #To Apply
										redirect_to apply_subscription_path(@user, @subscription_application)
									else 
										if @subscription_application.step == 7 then #To Review
											redirect_to pending_subscription_path(@user, @subscription_application)
										else
										
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	def payments
		@user = User.find(params[:id])
		@subscription_progression = 70
		@subscription_application = @user.subscription_application[0]
		#Redirect
		if @subscription_application.step != 4 then 
			if @subscription_application.step == 1 then #To Goals
				redirect_to goals_subscription_path(@user,@subscription_application)
			else
				if @subscription_application.step == 2 then #To Project
					redirect_to project_subscription_path(@user, @subscription_application)
				else
					if @subscription_application.step == 3 then #To Discussion
						redirect_to discussion_subscription_path(@user, @subscription_application)
					else
						if @subscription_application.step == 4 then #To Payments
							#redirect_to payments_subscription_path(@user, @subscription_application)
						else
							if @subscription_application.step == 5 then #To Identification
								redirect_to identification_subscription_path(@user, @subscription_application)
							else
								if @subscription_application.step == 6 then #To Apply
									redirect_to apply_subscription_path(@user, @subscription_application)
								else 
									if @subscription_application.step == 7 then #To Review
										redirect_to pending_subscription_path(@user, @subscription_application)
									else
										
									end
								end
							end
						end
					end
				end
			end
		end
	end

	def identification
		@user = User.find(params[:id])
		@subscription_progression = 84
		@subscription_application = @user.subscription_application[0]		
		#Redirect
		if @subscription_application.step != 5 then 
			if @subscription_application.step == 1 then #To Goals
				redirect_to goals_subscription_path(@user,@subscription_application)
			else
				if @subscription_application.step == 2 then #To Project
					redirect_to project_subscription_path(@user, @subscription_application)
				else
					if @subscription_application.step == 3 then #To Discussion
						redirect_to discussion_subscription_path(@user, @subscription_application)
					else
						if @subscription_application.step == 4 then #To Payments
							redirect_to payments_subscription_path(@user, @subscription_application)
						else
							if @subscription_application.step == 5 then #To Identification
								#redirect_to identification_subscription_path(@user, @subscription_application)
							else
								if @subscription_application.step == 6 then #To Apply
									redirect_to apply_subscription_path(@user, @subscription_application)
								else 
									if @subscription_application.step == 7 then #To Review
										redirect_to pending_subscription_path(@user, @subscription_application)
									else
										
									end
								end
							end
						end
					end
				end
			end
		end
	end

	def apply
		@user = User.find(params[:id])
		@subscription_progression = 98
		@subscription_application = @user.subscription_application[0]	
		@project = @user.projects.where(:published => true, :complete => false, :abandoned => false).first
		@discussion = @user.discussions.where(:published => true, :review_status => "Approved", :deleted => false).first		
		#Redirect
		if @subscription_application.step != 6 then 
			if @subscription_application.step == 1 then #To Goals
				redirect_to goals_subscription_path(@user,@subscription_application)
			else
				if @subscription_application.step == 2 then #To Project
					redirect_to project_subscription_path(@user, @subscription_application)
				else
					if @subscription_application.step == 3 then #To Discussion
						redirect_to discussion_subscription_path(@user, @subscription_application)
					else
						if @subscription_application.step == 4 then #To Payments
							redirect_to payments_subscription_path(@user, @subscription_application)
						else
							if @subscription_application.step == 5 then #To Identification
								redirect_to identification_subscription_path(@user, @subscription_application)
							else
								if @subscription_application.step == 6 then #To Apply
									#redirect_to apply_subscription_path(@user, @subscription_application)
								else 
									if @subscription_application.step == 7 then #To Review
										redirect_to pending_subscription_path(@user, @subscription_application)
									else
										
									end
								end
							end
						end
					end
				end
			end
		end
	end

	def pending
		@subscription_progression = 100
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
		if @subscription_application.step == 1 then #To Goals
			redirect_to goals_subscription_path(@user,@subscription_application)
		else
			if @subscription_application.step == 2 then #To Project
				redirect_to project_subscription_path(@user, @subscription_application)
			else
				if @subscription_application.step == 3 then #To Discussion
					redirect_to discussion_subscription_path(@user, @subscription_application)
				else
					if @subscription_application.step == 4 then #To Payments
						redirect_to payments_subscription_path(@user, @subscription_application)
					else
						if @subscription_application.step == 5 then #To Identification
							redirect_to identification_subscription_path(@user, @subscription_application)
						else
							if @subscription_application.step == 6 then #To Apply
								redirect_to apply_subscription_path(@user, @subscription_application)
							else 
								if @subscription_application.step == 7 then #To Review
									redirect_to pending_subscription_path(@user, @subscription_application)
								else
									redirect_to setup_subscription_path(@user) #To To Subscribers
								end
							end
						end
					end
				end
			end
		end
	end


end