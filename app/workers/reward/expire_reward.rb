class Reward::ExpireReward

	#Expire due reward
	@queue = :reward

	def self.perform(reward_id)
		if @reward = Reward.find(reward_id)
			if @reward.ended_early == nil 
				#Expire this reward
				@reward.update(
					expired: true,
					expired_at: Time.now,
					active: false
				)
				#Send notification
				Notification.create(
					user_id: @reward.user_id,
					trackable_id: @reward.id,
					trackable_type: "Reward",
					notification_type: "current_goal_due"
				)
			end
		end
	end
end