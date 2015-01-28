module DiscussionsHelper

	def level_2_threader(level_1_id)
		@discussion.discussion_threads.find(level_1_id).level_2[0]
	end

end