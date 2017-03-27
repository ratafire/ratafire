class Achievement::Daily

	#Checks the following achievements
	#Drifting into The Void

	@queue = :achievement

	def self.perform(achievement_name,user_id,count)
		if @user = User.find(user_id)
			if @achievement = Achievement.find_by_name(achievement_name)
				if @achievement_counter = AchievementCounter.find_by_user_id_and_achievement_id(user_id, @achievement.id)
					time_diff = (Time.now - @achievement_counter.updated_at)/1.day
					if time_diff > 2
						@achievement_counter.update(
							count: 0
						)
						Resque.enqueue(Achievement::Counter, achievement_name, user_id, count)
					else
						if time_diff > 1 && time_diff <= 2
							Resque.enqueue(Achievement::Counter, achievement_name, user_id, count)
						end
					end
				else
					Resque.enqueue(Achievement::Counter, achievement_name, user_id, count)
				end
			end
		end
	end

end