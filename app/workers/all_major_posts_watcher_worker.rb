class AllMajorPostsWatcherWorker
	@queue = :all_majorposts_watcher_queue

	def self.perform(project_id, user_id)
		project = Project.find(project_id)
		if project.majorposts? then
			project.majorposts.each do |majorpost|
				activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(majorpost.id,'Majorpost')
				if activity != nil then
					activity.watcher_list.add(user_id)
					activity.save
				end
			end
		end
	end
end