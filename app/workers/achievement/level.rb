class Achievement::Level

	#Checks the following achievements
	#Level 10
	#Level 20
	#Level 30
	#Level 40
	#Level 50
	#Level 60

	@queue = :achievement

	def self.perform(user_id)
		I18n.locale = :en
		#Set achievement name
		achievement_name = ""
		if @user = User.find(user_id)
			if @user.level == 60
				achievement_name = "Level 60"
			else
				if @user.level >= 50
					achievement_name = "Level 50"
				else
					if @user.level >= 40
						achievement_name = "Level 40"
					else
						if @user.level >= 30
							achievement_name = "Level 30"
						else
							if @user.level >= 20
								achievement_name = "Level 20"
							else
								if @user.level >= 10
									achievement_name = "Level 10"
								end
							end
						end
					end
				end
			end
		end
		#Find Achievement
		if @achievement = Achievement.find_by_name(achievement_name)
			unless AchievementRelationship.find_by_achievement_id_and_user_id(@achievement.id,@user.id)
				Resque.enqueue(Achievement::Create, achievement_name, @user.id)
			end
		end		
	end

end