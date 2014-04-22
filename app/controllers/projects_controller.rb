class ProjectsController < ApplicationController
	layout 'application'
	require 'will_paginate/array'
	before_filter :assigned_user, only: [:newmajorpost]
	before_filter :project_creator_and_admin, only: [:edit, :settings, :destroy]

	rescue_from "Mechanize::ResponseCodeError", with: :source_code_parser_404

	def show
		@project = Project.find(params[:id])
		@majorpost_count = @project.majorposts.where(:published => true).count
		#Video
		if @project.video_id != nil && @project.video_id != "" then
			@video = Video.find(@project.video_id)
		end
		#Artwork Original File
		if @project.artwork_id != "" && @project.artwork_id != nil then
			@artwork = Artwork.find(@project.artwork_id)
		end
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end
		#Hide drafts from non project.creator
		if @project.published == false && current_user != @project.creator
			redirect_to root_path
		else
			@majorpost = @project.majorposts.order("created_at").where(:published => true).first
			if @project.majorposts.where(:published => true).any? then
			@comments = @majorpost.comments.paginate(page: params[:comments], :per_page => 20)
			@comment = Comment.new(params[:comment])
			end
			@project_comments = @project.project_comments.paginate(page: params[:project_comments], :per_page => 10)
			@project_comment = ProjectComment.new(params[:project_comment])			
		end
		#bifrosts
		@bifrost = Bifrost.new(params[:bifrost])
		@bifrost.connections.build(params[:connection])
		#likes
		if user_signed_in? then
			if LikedProject.find_by_project_id_and_user_id(@project.id,current_user.id) != nil then
				@liked_project = true
			else
				@liked_project = false
			end
			if @majorpost != nil && LikedMajorpost.find_by_majorpost_id_and_user_id(@majorpost.id,current_user.id) != nil then
				@liked = true
			else
				@liked = false
			end
		end	
	end

	def update
		@project = Project.find(params[:id])
		respond_to do |format|
			if @project.update_attributes(params[:project]) then
				image_parser
				excerpt_generator
				@project.save
				format.json { respond_with_bip(@project) }
				#activity tags and realms
				@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
				if @activity != nil then
					@activity.realm = @project.realm
					@activity.tag_list = @project.tag_list
					@activity.commented_at = @project.commented_at
					if @project.published == true then
						@activity.draft = false
					end
					@activity.save
				end								
				if @project.published == true
					if @project.complete != true
						if @project.majorposts.where(:published => true).count < @project.goal then
							@project.flag = false
							@project.save
						end	
							format.html { redirect_to(user_project_path(@project.creator,@project), :notice => 'Project was successfully updated.') }				
					else
						format.html { redirect_to(user_project_path(@project.creator,@project), :notice => 'Project is completed!') }
					end
				else
					format.html { redirect_to(edit_user_project_path(@project.creator,@project), :notice => 'Project saved.') }
				end
				#source code
				if @project.source_code != nil && @project.source_code != "" then
					source_code_parser
					@project.save
				else
					@project.source_code_title = nil
					@project.save
				end
				#goal
				if @project.goal <= @project.majorposts.where(:published => true).count then
					@project.goal = @project.majorposts.where(:published => true).count+1
					@project.save
				end

			else
				format.html { render :action => "edit" }
				format.json { respond_with_bip(@project) }
			end
		end
	end

	def edit
		@project = Project.find(params[:id])
		if @project.realm != nil then
			@artwork = Artwork.new(params[:artwork])
			@icon = Icon.new(params[:icon])
			@video = Video.new(params[:video])
			@majorpost_count = @project.majorposts.where(:published => true).count
			#Artwork
			if @project.artwork_id != "" && @project.artwork_id != nil then
				@artwork = Artwork.find(@project.artwork_id)
			end	
			#Video
			if @project.video_id != "" && @project.video_id != nil then
				@video = Video.find(@project.video_id)
			end
			#Icon
			if @project.icon_id != "" && @project.icon_id != nil then
				@icon = Icon.find(@project.icon_id)
			end
		else
			redirect_to project_realms_path(@project.creator,@project)
		end
	end

	def realm
		@project = Project.find(params[:id])
		@majorpost_count = @project.majorposts.where(:published => true).count
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)
		end		
	end

	def create
		@project = Project.prefill!(:user_id => current_user.id)
		#AssignedProject
		@assignedproject = AssignedProject.new()
		@assignedproject.user_id = current_user.id
		@assignedproject.project_id = @project.id
		@assignedproject.save
		#render :text => @project.errors.full_messages to debug
		if @project != nil then
			redirect_to project_realms_path(@project.creator, @project)
		else
			redirect_to(:back)
		end
	end

	def settings
		@project = Project.find(params[:id])
		@majorpost_count = @project.majorposts.where(:published => true).count
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end		
	end

	def newmajorpost
		@project = Project.find(params[:id])
		@majorpost = Majorpost.new(params[:majorpost])
		@majorpost.m_u_inspirations.build(params[:m_u_inspiration])
		@majorpost.m_p_inspirations.build(params[:p_m_inspiration])
		@majorpost.m_m_inspirations.build(params[:m_m_inspiration])
		@majorpost.m_e_inspirations.build(params[:m_e_inspiration])
		@artwork = Artwork.new(params[:artwork])
	end

	def about
		@project = Project.find(params[:id])
		@majorpost_count = @project.majorposts.where(:published => true).count
		#bifrosts
		@bifrost = Bifrost.new(params[:bifrost])
		@bifrost.connections.build(params[:connection])
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end
	end

	def contributors
		@project = Project.find(params[:id])
		@majorpost_count = @project.majorposts.where(:published => true).count
		@contributors = @project.users.paginate(page: params[:page], :per_page => 10)
		port = Rails.env.production? ? "" : ":3000"
		@link = "#{request.scheme}://#{request.host}#{port}/#{@project.creator.username}/#{@project.slug }/contributors"
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end
		#ibifrosts
		@ibifrost = Ibifrost.new(params[:ibifrost])
		@ibifrost.inviteds.build(params[:invited])	
		#Inviteds
		if signed_in? then
			@invited = @project.inviteds.find_by_user_id(current_user.id)
		end	
	end

	def mplist
		@project = Project.find(params[:id])
		@majorpost = @project.majorposts.paginate(page: params[:page], :per_page => 20)
		@majorpost_count = @project.majorposts.where(:published => true).count
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end
	end

	def abandon
		@project = Project.find(params[:id])
		@project.abandoned = true
		@project.edit_permission = "freeze"
		@project.save
		@abandon_log = AbandonLog.new
		@abandon_log.project_id = @project.id
		@abandon_log.save
		redirect_to(:back)
	end

	def reopen
		@project = Project.find(params[:id])
		@abandon_log = @project.abandon_logs.first
		@abandon_log.reopen = Time.now
		@abandon_log.save
		@project.edit_permission = "edit"
		@project.abandoned = false
		@project.save
		redirect_to(:back)
	end

	def destroy
		@project = Project.find(params[:id])
		@user = @project.creator
		#Set Activities of the Project as deleted
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
		if @activity != nil then
			@activity.deleted = true
			@activity.deleted_at = Time.now
			@activity.save
		end
		#Set Project as deleted
		@project.deleted = true
		@project.deleted_at = Time.now
		@project.save
		flash[:success] = "Draft threw away, and you hit a pine nut."
		redirect_to projects_path(@user)
	end	

private

		def assigned_user
			@current_user_id = current_user.id
			redirect_to root_path unless Project.find(params[:id]).users.map(&:id).include?(@current_user_id)
		end

		def project_creator_and_admin
			if Project.find(params[:id]).creator == current_user then
			else
				if current_user.admin?
				else
					redirect_to root_path
				end
			end
		end

    	#Set Draft for project title
    	#def project_draft_title
    	#	time = DateTime.now.strftime("%H:%M").to_s
    	#	title = 'New Project ' + time
    	#	return title
    	#end

    	#Set pine nuts
    	def pine_nuts
    		s = DateTime.now.strftime("%S").to_i
    		m = DateTime.now.strftime("%M").to_i
    		h = DateTime.now.strftime("%H").to_i
    		e = s.to_s+m.to_s+h.to_s
    		return e
    	end

    	#get image from project
    	def image_parser
    		@project.projectimages.each do |i|
    			i.destroy
    		end
    		content = Nokogiri::HTML(@project.about)
    		project_images ||= Array.new
    		project_images = content.css('img').map{ |i| i['src']}
    		#rule out the external png image
    		project_images = project_images - ["/assets/externallink.png"]
    		project_images.each do |p|
    			@projectimage = Projectimage.new()
    			@projectimage.project_id = @project.id
    			@projectimage.url = p
    			splited = p.split("/")
    			#if it is a real Ratafire image!
    			if splited[3] == "Ratafire_production_images" || splited[3] == "Ratafire_test_images" then
    				urltemp = splited.pop
    				splited.push("thumbnail_"+urltemp)
    				@projectimage.thumbnail = splited.join("/")
    				@projectimage.save
    			end
    		end
    	end

    	def excerpt_generator
    		@project.excerpt = Sanitize.clean(@project.about)
    	end

	#See if the user is signed in?
    def signed_in_user
      unless signed_in?
        redirect_to new_user_session_path, notice:"Please sign in." unless signed_in?
      end
    end


end