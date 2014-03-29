class LikesController < ApplicationController

	def project
		@like = LikedProject.new
		@like.user_id = params[:user_id]
		@like.project_id = params[:project_id]
		@like.save
		#Activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:project_id],'Project')
		if @activity != nil then
			@activity.liker_list.add(params[:user_id])
			@activity.save
		end
		render :nothing => true
	end

	def majorpost
		@like = LikedMajorpost.new
		@like.user_id = params[:user_id]
		@like.majorpost_id = params[:majorpost_id]
		@like.save
		#Activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:majorpost_id],'Majorpost')
		if @activity != nil then
			@activity.liker_list.add(params[:user_id])
			@activity.save
		end	
		render :nothing => true
	end

	def comment
		@like = LikedComment.new
		@like.user_id = params[:user_id]
		@like.comment_id = params[:comment_id]
		@like.save
		#Activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:comment_id],'Comment')
		if @activity != nil then
			@activity.liker_list.add(params[:user_id])
			@activity.save
		end			
		render :nothing => true
	end

	def unlike_project
		@unlike = LikedProject.find_by_user_id_and_project_id(params[:user_id],params[:project_id])
		@unlike.destroy
		#Activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:project_id],'Project')
		if @activity != nil then
			@activity.liker_list.remove(params[:user_id])
			@activity.save
		end
		render :nothing => true
	end

	def unlike_majorpost
		@unlike = LikedMajorpost.find_by_user_id_and_majorpost_id(params[:user_id],params[:majorpost_id])
		@unlike.destroy
		#Activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:majorpost_id],'Majorpost')
		if @activity != nil then
			@activity.liker_list.remove(params[:user_id])
			@activity.save
		end		
		render :nothing => true
	end

	def unlike_comment
		@unlike = LikedComment.find_by_user_id_and_comment_id(params[:user_id],params[:comment_id])
		@unlike.destroy
		#Activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:comment_id],'Comment')
		if @activity != nil then
			@activity.liker_list.remove(params[:user_id])
			@activity.save
		end				
		render :nothing => true
	end
end	