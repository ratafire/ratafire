class WatchedsController < ApplicationController

	def project
		@watched = Watched.new
		@watched.user_id = params[:user_id]
		@watched.project_id = params[:project_id]
		@watched.save
		#Activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:project_id],'Project')
		if @activity != nil then
			@activity.watcher_list.add(params[:user_id])
			@activity.save
		end
		@project = Project.find(@watched.project_id)
		#Enque all major posts
		Resque.enqueue(AllMajorPostsWatcherWorker, @watched.project_id, @watched.user_id)	
	end

	def unwatch_project
		@watched = Watched.find_by_user_id_and_project_id(params[:user_id],params[:project_id])
		@watched.destroy
		#Activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:project_id],'Project')
		if @activity != nil then
			@activity.watcher_list.remove(params[:user_id])
			@activity.save
		end
		@project = Project.find(@watched.project_id)
		#Enque all major posts
		Resque.enqueue(AllMajorPostsRemoveWatcherWorker, @watched.project_id, @watched.user_id)		
	end	

end