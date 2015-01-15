class TutorialsController < ApplicationController

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

end