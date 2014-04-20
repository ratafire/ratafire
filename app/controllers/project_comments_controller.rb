class ProjectCommentsController < ApplicationController

	layout "application"

	def show
		@project_comment = ProjectComment.find(params[:id])
		@project = @project_comment.project
		@majorpost_count = @project.majorposts.where(:published => true).count		
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end		
	end

	def new
	end

	def create
		@project_comment = ProjectComment.new(params[:project_comment])
		@project = @project_comment.project
		if @project_comment.save
			image_parser
			excerpt_generator
			@project_comment.save
			@project.commented_at = Time.now
			@project.save
			@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
			if @activity != nil then
				@activity.commented_at = @project.commented_at
				@activity.save
			end
			flash[:success] = "You commented on the project!"
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
		@project_comment = ProjectComment.find(params[:id])
		@project = @project_comment.project
		#destroy activity as well
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project_comment.id,'ProjectComment')
		if @activity != nil then
			@activity.deleted = true
			@activity.deleted_at = Time.now
			@activity.save
		end
		#Set the comment as deleted
		@project_comment.deleted = true
		@project_comment.deleted_at = Time.now
		@project_comment.save
		@activity_project = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
		#Set project commentedback
		if @project.comments.where(:deleted => nil).count == 0 then
			@project.commented_at = @project.created_at
			@project.save
			@activity_project.commented_at = @project.created_at
			@activity_project.save
		else
			@activity_project.commented_at = @project.comments.last.created_at
			@activity_project.save
			@project.commented_at = @project.comments.last.created_at
			@project.save
		end
		flash[:success] = "Comment deleted."
		redirect_to(:back)
	end

private

	def image_parser
		@project_comment.commentimages.each do |i|
			i.destroy
		end
		content = Nokogiri::HTML(@project_comment.content)
		comment_images ||= Array.new
		comment_images = content.css('img').map{ |i| i['src']}
		#rule out the external png image
		comment_images = comment_images - ["/assets/externallink.png"]
		comment_images.each do |p|
			@commentimage = Commentimage.new()
			@commentimage.project_comment_id = @project_comment.id
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
		@project_comment.excerpt = Sanitize.clean(@project_comment.content)
	end
end