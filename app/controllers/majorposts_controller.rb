class MajorpostsController < ApplicationController
	layout "application"
	#autocomplete :tag_list, :name
	before_filter :check_for_mobile

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
		#Add Watchers
		if @project.watchers.any? then 
			Resque.enqueue(MajorPostWatcherWorker, @project.id, @majorpost.id)
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
					if @majorpost.published == true then
						@activity.draft = false
					end
					@activity.save
				end				
				#artwork
				if @majorpost.artwork_id != "" && @majorpost.artwork_id != nil then
					map_artwork
				end
				if @majorpost.published == true
					if title_parser(@majorpost.title) == false then
						@majorpost.published = false
						@majorpost.save
						format.html { redirect_to(edit_user_project_majorpost_path(@project.creator,@project, @majorpost), :notice => 'Please enter a title for this post.') }
					else
						if @majorpost.content == nil || @majorpost.content == "" then
							@majorpost.published = false
							@majorpost.save
							format.html { redirect_to(edit_user_project_majorpost_path(@project.creator,@project, @majorpost), :notice => 'Please enter the content of this post.') }
						else
							if @majorpost.tags.any? then
								#Set publish time when it is nil, which means it is the first time this majorpost goes public
								unless @majorpost.published_at != nil then
									@majorpost.published_at = Time.now
									#Check Early Access
									if @project.early_access == true then
										@majorpost.early_access = true
										Resque.enqueue_in(6.days,MajorpostEarlyAccessWorker,@majorpost.id)
									end
									@majorpost.save
								end
								#flag a project when it is over balanced its goal
								if @project.majorposts.where(:published => true).count == @project.goal then
									@project.flag = true
									@project.save
									format.html { redirect_to(user_project_majorpost_path(@project.creator,@project, @majorpost), :notice => 'Project completed?') }
								else
									format.html { redirect_to(user_project_majorpost_path(@project.creator,@project, @majorpost), :notice => 'Major post was successfully updated.') }
								end
							else
								@majorpost.published = false
								@majorpost.save
								format.html { redirect_to(edit_user_project_majorpost_path(@project.creator,@project, @majorpost), :notice => 'Please enter several tags for this post.') }
							end
						end
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
		@artwork = @majorpost.artwork

		#Video
		if @majorpost.video_id != "" && @majorpost.video_id != nil then
			@video = Video.find(@majorpost.video_id)
		end
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end		
		#Audio
		if @majorpost.audio_id != "" && @majorpost.audio_id != nil then
			@audio = Audio.find(@majorpost.audio_id)
			if @audio.soundcloud != nil then 
				@audio_embed = "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/"+@audio.soundcloud+"&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true"
			end			
		end
		#PDF
		if @majorpost.pdf_id != "" && @majorpost.pdf_id != nil then
			@pdf = Pdf.find(@majorpost.pdf_id)	
		end				
	end

	def show
		@majorpost = Majorpost.find(params[:id])
		#Audio
		if @majorpost.audio_id != "" && @majorpost.audio_id != nil then
			@audio = Audio.find(@majorpost.audio_id)
			if @audio.soundcloud != nil then 
				@audio_embed = "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/"+@audio.soundcloud+"&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true"
			end
		end		
		#PDF
		if @majorpost.pdf_id != "" && @majorpost.pdf_id != nil then
			@pdf = Pdf.find(@majorpost.pdf_id)	
		end				
		if @majorpost.early_access == true then
			if user_signed_in? then
				@user = @majorpost.user
				@subscription = Subscription.where(:deleted => false, :activated => true, :subscriber_id => current_user.id, :subscribed_id => @user.id).first
				if @subscription != nil then
					diff = ((@majorpost.published_at+6.days-Time.now)/1.day).to_i
					#current_user is subscribed to @user
					case @subscription.amount
					when ENV["PRICE_1"].to_f
							redirect_to(root_url)
							flash[:success] = "You do not have early access to this post."
					when ENV["PRICE_2"].to_f
						unless diff < 2 then
							redirect_to(root_url)
							flash[:success] = "You do not have early access to this post."
						else
							majorpost_show_main
						end
					when ENV["PRICE_3"].to_f
						unless diff < 3 then
							redirect_to(root_url)
							flash[:success] = "You do not have early access to this post."
						else
							majorpost_show_main
						end				
					when ENV["PRICE_4"].to_f
						unless diff < 4 then
							redirect_to(root_url)
							flash[:success] = "You do not have early access to this post."
						else
							majorpost_show_main
						end						
					when ENV["PRICE_5"].to_f
						unless diff < 5 then
							redirect_to(root_url)
							flash[:success] = "You do not have early access to this post."
						else
							majorpost_show_main
						end					
					when ENV["PRICE_6"].to_f
						majorpost_show_main			
					end						
				else
					if @majorpost.project.users.map(&:id).include? current_user.id then
						majorpost_show_main
					else
						redirect_to(root_url)
						flash[:success] = "You do not have early access to this post."
					end
				end
			else
				redirect_to(root_url)
				flash[:success] = "You do not have early access to this post."
			end
		else
			majorpost_show_main
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
		#Dequeue early access
		Resque.remove_delayed(MajorpostEarlyAccessWorker,@majorpost.id)
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
		if @project.majorposts.count == 0 then
			redirect_to user_project_path(@project.creator,@project)
		else
			redirect_to(:back)
		end
	end


private

	def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)		
	end

	def majorpost_draft_title
		time = DateTime.now.strftime("%H:%M:%S").to_s
		title = "Click to enter a title " + time
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
			if splited[3] == "Ratafire_production_images" || splited[3] == "Ratafire_test_images" then
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

	#Majorpost show method meain content
	def majorpost_show_main
			@project = Project.find(params[:project_id])
			@comments = @majorpost.comments.paginate(page: params[:comments], :per_page => 20)
			@comment = Comment.new(params[:comment])
			@majorpost_count = @project.majorposts.where(:published => true).count
			#Artwork Original File
			@artwork = @majorpost.artwork
			#Video
			@video = @majorpost.video
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

	def title_parser(title)
    	title_s = title.split(" ")
    	if title_s[0] == "Click" && title_s[1] == "to" && title_s[2] == "enter" && title_s[3] == "a" && title_s[4] == "title" then
    		return false
    	else
    		return true
    	end		
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