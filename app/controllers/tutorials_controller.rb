class TutorialsController < ApplicationController

	layout :resolve_layout

	#profile tutorials

	def profile_tutorial_step1
		@tutorial = Tutorial.find(params[:id])
		@tutorial.profile_tutorial_prev = @tutorial.profile_tutorial
		@tutorial.profile_tutorial = 1
		@tutorial.save
	end

	def profile_tutorial_step2
		@tutorial = Tutorial.find(params[:id])
		@tutorial.profile_tutorial_prev = @tutorial.profile_tutorial
		@tutorial.profile_tutorial = 2
		@tutorial.save
		if @tutorial.profile_tutorial_prev >= 2 then 
			@tutorial_processed = false
		end	
		if @tutorial.user.profilephoto? && @tutorial.user.bio != nil then 
			@tutorial.profile_tutorial = 4
			@tutorial.save
		else
			if @tutorial.user.profilephoto? then
			@tutorial.profile_tutorial = 3
			@tutorial.save				
			end			
		end
	end

	def profile_tutorial_step3
		@tutorial = Tutorial.find(params[:id])
		@tutorial.profile_tutorial_prev = @tutorial.profile_tutorial
		@tutorial.profile_tutorial = 3
		@tutorial.save
		if @tutorial.profile_tutorial_prev >= 3 then 
			@tutorial_processed = false
		end	
		if @tutorial.user.bio != nil then 
			@tutorial.profile_tutorial = 4
			@tutorial.save
			@tutorial_processed = false
		end
	end

	def profile_tutorial_step4
		@tutorial = Tutorial.find(params[:id])
		@tutorial.profile_tutorial_prev = @tutorial.profile_tutorial
		@tutorial.profile_tutorial = 4
		@tutorial.save
		if @tutorial.profile_tutorial_prev >= 4 then 
			@tutorial_processed = false
		end	
	end

	#project tutorials

	def project_tutorial_step1
		@tutorial = Tutorial.find(params[:id])
		@tutorial.project_tutorial_prev = @tutorial.project_tutorial
		@tutorial.project_tutorial = 1
		@tutorial.save
		if @tutorial.project_tutorial_prev >= 1 then 
			@tutorial_processed = false
		end	
	end

	def project_tutorial_step2
		@tutorial = Tutorial.find(params[:id])
		@tutorial.project_tutorial_prev = @tutorial.project_tutorial
		@tutorial.project_tutorial = 2
		@tutorial.save
		if @tutorial.project_tutorial_prev >= 2 then 
			@tutorial_processed = false
		end	
	end

	def project_tutorial_step3
		@tutorial = Tutorial.find(params[:id])
		@tutorial.project_tutorial_prev = @tutorial.project_tutorial
		@tutorial.project_tutorial = 3
		@tutorial.save
		if @tutorial.project_tutorial_prev >= 3 then 
			@tutorial_processed = false
		end	
	end

	#intro tutorials
	def intro
		@user = User.find(params[:id])
	end

	def after_intro
		if user_signed_in? then
			@tutorial = Tutorial.find_by_user_id(current_user.id)
			@tutorial.intro = 1
			@tutorial.save
			redirect_to(current_user)
		end
	end

	#After setting up subscription
	def subscription
		@user = User.find(params[:id])
	end

	#delete add facebook pages
	def add_facebook_pages
		@tutorial = Tutorial.find(params[:id])
		@tutorial.update_column(:facebook_page, true)
		@tutorial.save
	end

	def setup_subscription
		@tutorial = Tutorial.find(params[:id])
		@tutorial.update_column(:setup_subscription, true)
		@tutorial.save
	end

private

  	def resolve_layout
   		case action_name
    	when "intro","subscription"
      		"blank"
    	else
      		"application"
    	end
  	end	



end