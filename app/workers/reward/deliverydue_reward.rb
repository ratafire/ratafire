class Reward::DeliverydueReward

	#Deliverydue reward
	@queue = :reward

	def self.perform(reward_id)
		if @reward = Reward.find(reward_id)
			#Expire the estimated delivery reward
			@reward.update(
				estimated_delivery_expired: true,
				estimated_delivery_expired_at: Time.now
			)
			#Send notification
			Notification.create(
				user_id: @reward.user_id,
				trackable_id: @reward.id,
				trackable_type: "Reward",
				notification_type: "estimated_delivery_due"
			)
		end
	end

end