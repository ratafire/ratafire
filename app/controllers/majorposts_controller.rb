class MajorpostsController < ApplicationController
	layout "application"
	#autocomplete :tag_list, :name

	def create
		@project = Project.find(params[:id])
		@majorpost = Majorpost.new()
		@majorpost.user = current_user
		@majorpost.title = majorpost_draft_title
		@majorpost.perlink = pine_nuts + (Majorpost.count+1).to_s
		@majorpost.published = false
		@majorpost.project = @project
		@majorpost.commented_at = Time.now
		if @majorpost.save then
		redirect_to edit_user_project_majorpost_path(@project.creator, @project, @majorpost)
		else
		redirect_to(:back)
		end
	end

	def update
		@majorpost = Majorpost.find(params[:id])
		@project = @majorpost.project
		respond_to do |format|
			if @majorpost.update_attributes(params[:majorpost]) then 
				image_parser
				excerpt_generator
				@majorpost.save
				format.json { respond_with_bip(@majorpost) }
				#activity tags
				@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
				if @activity != nil then
					@activity.tag_list = @majorpost.tag_list
					@activity.commented_at = @majorpost.commented_at
					@activity.save
				end				
				#artwork
				if @majorpost.artwork_id != "" && @majorpost.artwork_id != nil then
					map_artwork
				end
				if @majorpost.published == true
					#flag a project when it is over balanced its goal
					if @project.majorposts.where(:published => true).count == @project.goal then
						@project.flag = true
						@project.save
						format.html { redirect_to(user_project_majorpost_path(@project.creator,@project, @majorpost), :notice => 'Project completed?') }
					else
						format.html { redirect_to(user_project_majorpost_path(@project.creator,@project, @majorpost), :notice => 'Major post was successfully updated.') }
					end
				else
					format.html { redirect_to(edit_user_project_majorpost_path(@project.creator,@project, @majorpost), :notice => 'Major post saved.') }
				end	
			else
				format.html { render :action => "edit" }
				format.json { respond_with_bip(@majorpost) }			
			end
		end
	end

	def edit
		@majorpost = Majorpost.find(params[:id])
		@project = @majorpost.project
		@artwork = Artwork.new(params[:artwork])
		@video = Video.new(params[:video])
		@majorpost_count = @project.majorposts.where(:published => true).count
		#Artwork
		if @majorpost.artwork_id != "" && @majorpost.artwork_id != nil then
			@artwork = Artwork.find(@majorpost.artwork_id)
		end
		#Video
		if @majorpost.video_id != "" && @majorpost.video_id != nil then
			@video = Video.find(@majorpost.video_id)
		end
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end		
	end

	def show
		@majorpost = Majorpost.find(params[:id])
		@project = Project.find(params[:project_id])
		@comments = @majorpost.comments.paginate(page: params[:comments], :per_page => 20)
		@comment = Comment.new(params[:comment])
		@majorpost_count = @project.majorposts.where(:published => true).count
		#Artwork Original File
		if @majorpost.artwork_id != "" && @majorpost.artwork_id != nil then
			@artwork = Artwork.find(@majorpost.artwork_id)
		end
		#Video
		if @majorpost.video_id != nil && @majorpost.video_id != "" then
			@video = Video.find(@majorpost.video_id)
		end
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end
		#bifrosts
		@bifrost = Bifrost.new(params[:bifrost])
		@bifrost.connections.build(params[:connection])	
		#likes majorpost
		if user_signed_in? then
			if LikedMajorpost.find_by_majorpost_id_and_user_id(@majorpost.id,current_user.id) != nil then
				@liked = true
			else
				@liked = false
			end
		end	
	end

	def chapter
		@majorpost = Majorpost.find(params[:id])
		@project = Project.find(params[:project_id])
	end

	def destroy
		@majorpost = Majorpost.find(params[:id])
		@project = @majorpost.project
		@video = @majorpost.video
		#destroy majorpost activity as well
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
		if @activity != nil then
			@activity.deleted = true
			@activity.deleted_at = Time.now
			@activity.save
		end
		#destroy the activities of the comments of the majorpost
		@majorpost.comments.each do |c|
			comment_activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(c.id,'Comment')
			comment_activity.deleted = true
			comment_activity.deleted_at = Time.now
			comment_activity.save
		end
		#Set Majorpost as deleted
		@majorpost.deleted = true
		@majorpost.deleted_at = Time.now
		@majorpost.save
		#unflag a project when it is over balanced its goal
		if @project.majorposts.where(:published => true).count < @project.goal then
			@project.flag = false
			@project.save
			flash[:success] = "One step away..."
		else
			flash[:success] = "Majorpost deleted."
		end				
		redirect_to(:back)
	end


private

	def majorpost_draft_title
		time = DateTime.now.strftime("%H:%M:%S").to_s
		title = "New Major Post " + time
		return title	
	end

    #Set pine nuts
    def pine_nuts
    	s = DateTime.now.strftime("%S").to_i
    	m = DateTime.now.strftime("%M").to_i
    	h = DateTime.now.strftime("%H").to_i
    	e = (s*m*Math.log(h+2)).to_i.to_s
    	return e
    end

	def image_parser
		@majorpost.postimages.each do |i|
			i.destroy
		end
		content = Nokogiri::HTML(@majorpost.content)
		post_images ||= Array.new
		post_images = content.css('img').map{ |i| i['src'] }
		#rule out the external png image
		post_images = post_images - ["/assets/externallink.png"]
		post_images.each do |p|
			@postimage = Postimage.new()
			@postimage.majorpost_id = @majorpost.id
			@postimage.url = p
			splited = p.split("/")
			#if it is a real Ratafire image!
			if splited[3] == "Ratafire_images" then
				urltemp = splited.pop
				splited.push("thumbnail_"+urltemp) 
				@postimage.thumbnail = splited.join("/")
				@postimage.save
			end
		end
	end    

	def excerpt_generator
		@majorpost.excerpt = Sanitize.clean(@majorpost.content)
	end
#Old Mapping methods after save

	def map_artwork
		@artwork = Artwork.find(@majorpost.artwork_id)
		@artwork.majorpost_id = @majorpost.id
		@artwork.save
	end

	#See if the user is signed in?
    def signed_in_user
      unless signed_in?
        redirect_to new_user_session_path, notice:"Please sign in." unless signed_in?
      end
    end	

end