class MajorpostEarlyAccessWorker
	@queue = :majorpost_early_access_queue
	def self.perform(majorpost_id)
		majorpost = Majorpost.find(majorpost_id)
		majorpost.early_access = false
		majorpost.commented_at = Time.now
		majorpost.save
	end
end