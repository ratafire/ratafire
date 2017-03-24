class Achievement::PageVisit

	#Checks the following achievements
	#Drifting into The Void

	@queue = :achievement

	def self.perform(achievement_name,user_id)
		if @user = User.find(user_id)
			case achievement_name
			when 'Drifting into The Void'
				if @achievement = Achievement.find_by_name(achievement_name)
					unless AchievementRelationship.find_by_achievement_id_and_user_id(@achievement.id,@user.id)
						Resque.enqueue(Achievement::Create, achievement_name, @user.id)
					end
				end		
			end
		end
	end

end