class Achievement::Setcounter

	#Checks the following achievements
	#Drifting into The Void

	@queue = :achievement

	def self.perform(achievement_name,user_id,count)
		if @user = User.find(user_id)
			if @achievement = Achievement.find_by_name(achievement_name)
				if @achievement.count_goal
					#Has the counter
					if @achievement_counter = AchievementCounter.find_by_user_id_and_achievement_id(user_id, @achievement.id)
						if @achievement_counter.count < @achievement.count_goal
							if count <= 0
								@achievement_counter.update(
									count: 0
								)
							else
								@achievement_counter.update(
									count: count
								)
							end
							@achievement_count_updated = true
						end
					else
						if count <= 0
							@achievement_counter = AchievementCounter.create(
								user_id: user_id,
								achievement_id: @achievement.id,
								count: 0,
								count_goal: @achievement.count_goal
							)
						else
							@achievement_counter = AchievementCounter.create(
								user_id: user_id,
								achievement_id: @achievement.id,
								count: count,
								count_goal: @achievement.count_goal
							)
						end
						@achievement_count_updated = true
					end
					#Check if the count reaches the limit
					if @achievement_counter.count >= @achievement.count_goal && @achievement_count_updated == true
						@achievement_counter.update(
							count: @achievement.count_goal
						)
						#Make achievement
						unless AchievementRelationship.find_by_achievement_id_and_user_id(@achievement.id,@user.id)
							Resque.enqueue(Achievement::Create, achievement_name, @user.id)
						end
					end
				end
			end		
		end
	end

end