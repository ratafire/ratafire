class Achievement::FollowLess

	@queue = :achievement

	def self.perform(liker_id, liked_id)
		if @liker = User.find(liker_id)
			if @liked = User.find(liked_id)
				if @liked_record = LikedRecord.find_by_liker_id_and_liked_id(liker_id,liked_id)
					@followers = @liked.likers.count
					if @followers < 100 && @liked_record.counter <= 1
						unless @liker.achievements.where(name: "Scout").any?
							Resque.enqueue(Achievement::Counter, "Scout", liker_id, 1) #50
						end
						unless @liker.achievements.where(name: "Ranger").any?
							Resque.enqueue(Achievement::Counter, "Ranger", liker_id, 1) #50
						end
						unless @liker.achievements.where(name: "Seeker").any?
							Resque.enqueue(Achievement::Counter, "Seeker", liker_id, 1) #50
						end
						unless @liker.achievements.where(name: "Pathfinder").any?
							Resque.enqueue(Achievement::Counter, "Pathfinder", liker_id, 1) #50
						end
					end
				end
			end
		end
	end

end