class CommentsController < ApplicationController

	layout "application"

	def show
		@comment = Comment.find(params[:id])
		@project = @comment.project
		@majorpost = @comment.majorpost
		@majorpost_count = @project.majorposts.where(:published => true).count
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end		
	end

	def new
	end

	def create
		@comment = Comment.new(params[:comment])
		@majorpost = @comment.majorpost
		if @comment.save
			image_parser
			excerpt_generator
			@comment.save
			if @majorpost.comments.where(:deleted => nil).count == 1 then
				@majorpost.edit_permission = "edit"
				@majorpost.commented_at = Time.now
				@majorpost.save
				@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
				if @activity != nil then
					@activity.commented_at = @majorpost.commented_at
					@activity.save
				end
			else
				@majorpost.commented_at = Time.now
				@majorpost.save
				@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
				if @activity != nil then
					@activity.commented_at = @majorpost.commented_at
					@activity.save
				end				
			end
			flash[:success] = "You commented on the post!"
			redirect_to(:back)
		else
			flash[:error] = "'_' Unsucessful comment submission. Comment can't be blank or shorter than 24 characters."
			redirect_to(:back)
		end
	end

	def update
		redirect_to(:back)
	end

	def destroy
		@comment = Comment.find(params[:id])
		@majorpost = @comment.majorpost
		#destroy activity as well
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@comment.id,'Comment')
		if @activity != nil then
			@activity.deleted = true
			@activity.deleted_at = Time.now
			@activity.save
		end
		#Set the comment as deleted
		@comment.deleted = true
		@comment.deleted_at = Time.now
		@comment.save
		@activity_majorpost = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
		#Set majorpost back to deletable
		if @majorpost.comments.where(:deleted => nil).count == 0 then
			@majorpost.edit_permission = "free"
			@majorpost.commented_at = @majorpost.created_at
			@majorpost.save
			@activity_majorpost.commented_at = @majorpost.created_at
			@activity_majorpost.save
		else	
			@activity_majorpost.commented_at = @majorpost.comments.last.created_at
			@activity_majorpost.save
			@majorpost.commented_at = @majorpost.comments.last.created_at
			@majorpost.save
		end
		flash[:success] = "Comment deleted."
		redirect_to(:back)
	end

	def confirm_destroy
		@comment = Comment.find(params[:id])
	end

private
	
	def image_parser
		@comment.commentimages.each do |i|
			i.destroy
		end
		content = Nokogiri::HTML(@comment.content)
		comment_images ||= Array.new
		comment_images = content.css('img').map{ |i| i['src']}
		#rule out the external png image
		comment_images = comment_images - ["/assets/externallink.png"]
		comment_images.each do |p|
			@commentimage = Commentimage.new()
			@commentimage.comment_id = @comment.id
			@commentimage.url = p
			splited = p.split("/")
			#if it is a real Ratafire image!
			if splited[3] == "Ratafire_production_images" || splited[3] == "Ratafire_test_images" then
				urltemp = splited.pop
				splited.push("thumbnail_"+urltemp)
				@commentimage.thumbnail = splited.join("/")
				@commentimage.save
			end
		end
	end

	def excerpt_generator
		@comment.excerpt = Sanitize.clean(@comment.content)
	end
end