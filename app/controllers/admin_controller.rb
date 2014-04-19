class AdminController < ApplicationController
	layout 'application'
	before_filter :admin_user

	def test
	end

	def content
		respond_to do |format|
    		format.html
    		format.json { render json: StaffpicksDatatable.new(view_context) }
  		end
	end

	#This is a test for Resque workder: TestWorker
	def test_resque
		Resque.enqueue(TestWorker)
	end

	#This handles the request for staff picks
	def staff_pick
		url = params[:url]
		if url != nil then
			#See if it is an internal link

				splitted = url.split("/")
				@project_slug = splitted[4]
				@majorpost_slug = splitted[5]

				#get model
				@project = Project.find_by_perlink(@project_slug)
				@majorpost = Majorpost.find_by_slug(@majorpost_slug)

				#Do the work
				#Project
				if @project != nil && @majorpost == nil then
					@project.featured = true 
					@project.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
					if @activity != nil then
						@activity.featured = true
						@activity.save
					end
					flash[:success] = "You featured "+@project.title+" !"	
				end

				#Majorpost
				if @project != nil && @majorpost != nil then
					@majorpost.featured = true
					@majorpost.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
					if @activity != nil then
						@activity.featured = true
						@activity.save
					end
					flash[:success] = "You featured "+@majorpost.title+" !"							
				end

		else
			flash[:success] = "No url!"			
		end	
		redirect_to(:back)
	end

	#This is the request to delete project staffpicks
	def project_staff_picks_delete
		@project = Project.find(params[:project_id])
		@project.featured = nil
		@project.save

		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
		if @activity != nil then
			@activity.featured = nil
			@activity.save
		end

		flash[:success] = "You unpicked "+@project.title+" !"
		redirect_to(:back)
	end
	
private

	def admin_user
      redirect_to(root_url) unless current_user.admin?
    end	
end