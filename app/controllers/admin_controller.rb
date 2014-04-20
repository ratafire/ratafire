class AdminController < ApplicationController
	layout 'application'
	before_filter :admin_user

	def test
	end

	def content
	end

	def content_project
		respond_to do |format|
    		format.html
    		format.json { render json: StaffpicksDatatable.new(view_context) }
  		end		
	end

	def content_majorpost
		respond_to do |format|
    		format.html
    		format.json { render json: StaffpicksMajorpostsDatatable.new(view_context) }
  		end		
	end

	def content_deleted_project
		respond_to do |format|
    		format.html
    		format.json { render json: DeletedProjectsDatatable.new(view_context) }
  		end	
	end

	def content_deleted_majorpost
		respond_to do |format|
    		format.html
    		format.json { render json: DeletedMajorpostsDatatable.new(view_context) }
  		end	
	end	

	def content_deleted_comment
		respond_to do |format|
    		format.html
    		format.json { render json: DeletedCommentsDatatable.new(view_context) }
  		end	
	end		

	def content_deleted_project_comment
		respond_to do |format|
    		format.html
    		format.json { render json: DeletedProjectcommentsDatatable.new(view_context) }
  		end	
	end		

	def test_projects
		respond_to do |format|
    		format.html
    		format.json { render json: TestProjectsDatatable.new(view_context) }
  		end	
	end		

	def test_majorposts
		respond_to do |format|
    		format.html
    		format.json { render json: TestMajorpostsDatatable.new(view_context) }
  		end	
	end				

	#This is a test for Resque workder: TestWorker
	def test_resque
		Resque.enqueue(TestWorker)
	end

	#This is for adding tests
	def add_tests
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
					@project.test = true 
					@project.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
					if @activity != nil then
						@activity.test = true
						@activity.save
					end
					flash[:success] = "You tested "+@project.title+" !"	
				end

				#Majorpost
				if @project != nil && @majorpost != nil then
					@majorpost.test = true
					@majorpost.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
					if @activity != nil then
						@activity.test = true
						@activity.save
					end
					flash[:success] = "You tested "+@majorpost.title+" !"							
				end

		else
			flash[:success] = "No url!"			
		end	
		redirect_to(:back)
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

	#This is the request to delete majorpost staffpicks
	def majorpost_staff_picks_delete
		@majorpost = Majorpost.find(params[:majorpost_id])
		@majorpost.featured = nil
		@majorpost.save

		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
		if @activity != nil then
			@activity.featured = nil
			@activity.save
		end

		flash[:success] = "You unpicked "+@majorpost.title+" !"
		redirect_to(:back)
	end	

	#This handles the deletion of content
	def delete_content
		url = params[:url]
		if url != nil then
				splitted = url.split("/")
				#See if this is a comment
				if splitted[4] == "projects" then
					@project_slug = splitted[5]
					#See if this is a project comment
					unless splitted[6] == "project_comments" then
						@majorpost_slug = splitted[7]
						@comment_id = splitted[9]
					else
						@project_comment_id = splitted[7]
					end
				else
					@project_slug = splitted[4]
					@majorpost_slug = splitted[5]	
				end	

				#Do the work
				#Project
				if @project_slug != nil && @majorpost_slug == nil && @project_comment_id == nil then
					@project = Project.find_by_perlink(@project_slug)
					@project.deleted = true
					@project.deleted_at = Time.now
					@project.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
					if @activity != nil then
						@activity.deleted = true
						@activity.deleted_at = Time.now
						@activity.save
					end
					flash[:success] = "You deleted project "+@project.title+" !"
				end

				#Majorpost
				if @project_slug != nil && @majorpost_slug != nil && @comment_id == nil then
					@majorpost = Majorpost.find_by_slug(@majorpost_slug)
					@majorpost.deleted = true
					@majorpost.deleted_at = Time.now
					@majorpost.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
					if @activity != nil then
						@activity.deleted = true
						@activity.deleted_at = Time.now
						@activity.save
					end
					flash[:success] = "You deleted majorpost "+@majorpost.title+" !"
				end

				#Comment
				if @comment_id != nil then
					@comment = Comment.find(@comment_id)
					@comment.deleted = true
					@comment.deleted_at = Time.now
					@comment.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@comment.id,'Comment')
					if @activity != nil then
						@activity.deleted = true
						@activity.deleted_at = Time.now
						@activity.save
					end
					flash[:success] = "You deleted comment "+@comment.id.to_s+" !"					
				end

				#Project Comment
				if @project_comment_id != nil then
					@project_comment = ProjectComment.find(@comment_id)
					@project_comment.deleted = true
					@project_comment.deleted_at = Time.now
					@project_comment.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project_comment.id,'ProjectComment')
					if @activity != nil then
						@activity.deleted = true
						@activity.deleted_at = Time.now
						@activity.save
					end
					flash[:success] = "You deleted project comment "+@project_comment.id.to_s+" !"							
				end

		end
		redirect_to(:back)
	end

	#This is for restoring content
	def restore
		if params[:type] == "Project" then
			@project = Project.find_by_deleted_and_id(true,params[:id])
			@project.deleted = false
			@project.deleted_at = nil
			@project.save
			flash[:success] = "You restored project "+@project.title+" !"
		else
			if params[:type] == "Majorpost" then
				@majorpost = Majorpost.find_by_deleted_and_id(true,params[:id])
				@majorpost.deleted = false
				@majorpost.deleted_at = nil
				@majorpost.save
				flash[:success] = "You restored majorpost "+@majorpost.title+" !"
			else
				if params[:type] == "Comment" then
					@comment = Comment.find_by_deleted_and_id(true,params[:id])
					@comment.deleted = false
					@comment.deleted_at = nil
					@comment.save
					flash[:success] = "You restored comment "+@comment.id.to_s+" !"
				else
					if params[:type] == "ProjectComment" then
						@project_comment = ProjectComment.find_by_deleted_and_id(true,params[:id])
						@project_comment.deleted = false
						@project_comment.deleted_at = nil
						@project_comment.save
						flash[:success] = "You restored project comment "+@project_comment.id.to_s+" !"
					end
				end
			end
		end
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:id],params[:type])
		if @activity != nil then
			@activity.deleted = false
			@activity.deleted_at = nil
			@activity.save
		end
		redirect_to(:back)
	end

	#This is for untest
	def untest
		if params[:type] == "Project" then
			@project = Project.find_by_test_and_id(true,params[:id])
			@project.test = false
			@project.save
			flash[:success] = "You untested project "+@project.title+" !"
		else
			if params[:type] == "Majorpost" then
				@majorpost = Majorpost.find_by_test_and_id(true,params[:id])
				@majorpost.test = false
				@majorpost.save
				flash[:success] = "You untested majorpost "+@majorpost.title+" !"
			end
		end
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:id],params[:type])
		if @activity != nil then
			@activity.test = false
			@activity.save
		end
		redirect_to(:back)		
	end
	
private

	def admin_user
      redirect_to(root_url) unless current_user.admin?
    end	
end