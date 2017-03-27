class Achievement::RecruitFriend

	#Checks the following achievements
	#The More The Merrier

	@queue = :achievement

	def self.perform(user_id)
		I18n.locale = :en
		#Set achievement name
		achievement_name = ""
		if @user = User.find(user_id)
			@all_users = User.where(invitation_token: nil, invited_by_id: @user.id)
			if @all_users.count >= 1
				achievement_name = "The More The Merrier"
				#Check if the user has the achievement: The More The Merrier
				if @achievement = Achievement.find_by_name(achievement_name)
					unless AchievementRelationship.find_by_achievement_id_and_user_id(@achievement.id,@user.id)
						Resque.enqueue(Achievement::Create, achievement_name, @user.id)
					end
				end
			end
			unless @user.achievements.where(name: "300").any?
				#Friend recruit counter
				Resque.enqueue(Achievement::Counter, "300", @user.id, 1) #300
			end
		end
	end

end