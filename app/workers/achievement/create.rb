class Achievement::Create

	#Temporarily replaces webhook
	@queue = :achievement

	def self.perform(achievement_name, user_id)
		if @user = User.find(user_id)
			if @achievement = Achievement.find_by_name(achievement_name)
				#Add achievement to user
				@achievement_relationship = AchievementRelationship.create(
					user_id: @user.id,
					achievement_id: @achievement.id
				)
				#Add achievement points to user
				@user.update(
					achievement_points: @user.achievement_points + @achievement.achievement_points
				)
				#Send notification
				Notification.create(
					user_id: @user.id,
					trackable_id: @achievement.id,
					trackable_type: "Achievement",
					notification_type: "achievement_create"
				)
			end
		end
	end

end