class ProjectsController < ApplicationController
	layout 'application'
	require 'will_paginate/array'
	before_filter :assigned_user, only: [:newmajorpost]
	before_filter :project_creator_and_admin, only: [:edit, :settings, :destroy]
	before_filter :check_for_mobile

	rescue_from "Mechanize::ResponseCodeError", with: :source_code_parser_404

	def show
		@project = Project.find(params[:id])
		@majorpost_count = @project.majorposts.where(:published => true).count
		if @majorpost_count == nil then
			@majorpost_count = 0
		end
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
		#Audio
		if @project.audio_id != "" && @project.audio_id != nil then
			@audio = Audio.find(@project.audio_id)
		end		
		#PDF
		if @project.pdf_id != "" && @project.pdf_id != nil then
			@pdf = Pdf.find(@project.pdf_id)
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
			@project_comments = @project.project_comments.order(:cached_weighted_score => :desc, :created_at => :desc).paginate(page: params[:project_comments], :per_page => 5)
			@project_comment = ProjectComment.new(params[:project_comment])		
			if current_user != nil then	
				@current_user_project_comment = ProjectComment.find_by_user_id_and_project_id(current_user.id, @project.id)
			end
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
			#Mutual friends
			@mutualfriends = @project.creator.friends & current_user.friends
		end	
		#Subscribers
		@subscribers = @project.creator.sub_susers.paginate(page: params[:sub_sus], :per_page => 11)
		@subscribers_others = (@subscribers.count-2).to_s + " others"
	end

	def update_title_and_tagline
		@project = Project.find(params[:id])
		respond_to do |format|
			if @project.update_attributes(params[:project]) then
				format.json { respond_with_bip(@project) }
			else
				format.json { respond_with_bip(@project) }
			end
		end
	end

	def update
		@project = Project.find(params[:id])

		if @project.update_attributes(params[:project]) then
			image_parser
			excerpt_generator
			@project.save
			#respond_to do |format|
			#	respond_to.json { respond_with_bip(@project) }
			#end
			update_activity_tags_and_realms
			#published							
			if @project.published == true
				#push those stupid people back, if they want to not enter title or tagline!!!!
				if title_parser(@project.title) == true then
					if tagline_parser(@project.tagline) == true then
						if @project.about == nil or @project.about == "" then 
							@project.published = false
							@project.save
							flash["success"] = 'Please write a description for this work collection.'
							redirect_to edit_user_project_path(@project.creator,@project)							
						else
							if @project.icon == nil then 
								@project.published = false
								@project.save
								flash["success"] = 'Please upload an icon for this work collection.'
								redirect_to edit_user_project_path(@project.creator,@project)					
							else
								if @project.tags.any? then
									if @project.complete != true
										if @project.majorposts.where(:published => true).count < @project.goal then
											@project.flag = false
											@project.save
										end	
										#Redirect to Connect to Facebook if User haven't connect to Facebook Update
										if @project.post_to_facebook == true then
											@project.creator.update_column(:post_to_facebook,true)
											if @project.post_to_facebook_page == true then
												if @project.creator.facebook_pages.first != nil then 
													@project.creator.facebook_pages.first.update_column(:post_to_facebook_page,true)
												end
												#With Facebook, with Facebook Pag
												redirect_to user_omniauth_authorize_path(:facebookposts, object_type: "work_collection", object_id: @project.id, post_to_both: "true")
											else
												#Set user preference to not post to facebook page
												if @project.creator.facebook_pages.first != nil then 
													@project.creator.facebook_pages.first.update_column(:post_to_facebook_page,nil)
												end
												#With Facebook, without Facebook Pag
												redirect_to user_omniauth_authorize_path(:facebookposts, object_type: "work_collection", object_id: @project.id)
											end
										else
											#Set user preference to not post to facebook
											@project.creator.update_column(:post_to_facebook,nil)
											if @project.post_to_facebook_page == true then
												if @project.creator.facebook_pages.first != nil then 
													@project.creator.facebook_pages.first.update_column(:post_to_facebook_page,true)
												end
												#Without Facebook, with Facebook Page
												Resque.enqueue(FacebookPostWorker,@project.creator.id, "work_collection",@project.id, :post_to_page => true)
											else
												#Set user preference to not post to faceboo
												if @project.creator.facebook_pages.first != nil then 
													@project.creator.facebook_pages.first.update_column(:post_to_facebook_page,nil)
												end
											end
											#Redirect to Setup subscription if so
											if @project.creator.subscription_application[0] != nil && @user.subscription_application[0].step != 7 then
												redirect_to goals_subscription_path(@project.creator)
											else
												flash["success"] = 'Work collection was successfully updated.'
												redirect_to user_project_path(@project.creator,@project)
											end				
										end
									else
										flash["success"] = 'Work collection is completed!'
										redirect_to user_project_path(@project.creator,@project)
									end
								else
									@project.published = false
									@project.save
									flash["success"] = 'Please add several tags for this work collection.'
									redirect_to edit_user_project_path(@project.creator,@project)										
								end
							end
						end
					else
						@project.published = false
						@project.save
						flash["success"] = 'Please enter a tagline for this work collection.'
						redirect_to edit_user_project_path(@project.creator,@project)					
					end
				else
					@project.published = false
					@project.save
					flash["success"] = 'Please enter a title for this work collection.'
					redirect_to edit_user_project_path(@project.creator,@project)
				end
			else
				flash["success"] = 'Work collection saved.'
				redirect_to edit_user_project_path(@project.creator,@project)
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
			redirect_to edit_user_project_path(@project.creator,@project)
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
			#Audio
			if @project.audio_id != "" && @project.audio_id != nil then
				@audio = Audio.find(@project.audio_id)
			end
			#PDF
			if @project.pdf_id != "" && @project.pdf_id != nil then
				@pdf = Pdf.find(@project.pdf_id)
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
		redirect_to user_path(@project.creator)
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
		flash[:success] = "Draft thrown away, and you hit a pine nut."
		redirect_to projects_path(@user)
	end	

	#Turn on and off early access
	def early_access_turnon
		@project = Project.find(params[:id])
		@project.early_access = true
		if @project.save then
			redirect_to(:back)
		else
			redirect_to(:back)
			flash[:success] = "Failed to turn on early access for this project."
		end
	end

	def early_access_turnoff
		@project = Project.find(params[:id])
		@project.early_access = false
		if @project.save then
			render nothing: true
		else
			redirect_to(:back)
			flash[:success] = "Failed to turn off early access for this project."
		end
	end	

	def recommanders
		@project = Project.find(params[:id])
		@recommanders = @project.likers.paginate(page: params[:page], :per_page => 32)
	end

	def watchers
		@project = Project.find(params[:id])
		@watchers = @project.watchers.paginate(page: params[:page], :per_page => 32)
	end

private

		def update_activity_tags_and_realms
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
		end

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

    	def title_parser(title)
    		title_s = title.split(" ")
    		if title_s[0] == "Click" && title_s[1] == "to" && title_s[2] == "enter" && title_s[3] == "a" && title_s[4] == "title" then
    			return false
    		else
    			return true
    		end
    	end

    	def tagline_parser(tagline)
    		tagline_s = tagline.split(" ")
    		if tagline_s[1] == "pine" && tagline_s[2] == "nuts" && tagline_s[3] == "on" && tagline_s[4] == "the" then
    			return false
    		else
    			return true
    		end
    	end

	#See if the user is signed in?
    def signed_in_user
      unless signed_in?
        redirect_to new_user_session_path, notice:"Please sign in." unless signed_in?
      end
    end


end