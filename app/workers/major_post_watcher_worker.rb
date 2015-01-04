class MajorPostWatcherWorker

	@queue = :major_post_watcher_worker
	#could be retrying all the time, this has to be thread save

	def self.perform(project_id, majorpost_id)
		project = Project.find(project_id)
		majorpost = Majorpost.find(majorpost_id)
		if majorpost != nil then 
			project.watcher_list.each do |watcher_id|
				activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(majorpost.id,'Majorpost')
					if activity != nil then
						activity.watcher_list.add(watcher_id)
						activity.save
					end					
			end
		end
	end
end