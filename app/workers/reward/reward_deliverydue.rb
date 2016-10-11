class Reward::RewardDeliverydue

	#Put due estimated delivery on queue
	@queue = :reward

	def self.perform
		Reward.where(deleted: nil, estimated_delivery_expired: nil, estimated_delivery_expiration_queued: nil).each do |reward|
			#Check if the estimated delivery is due
			if (reward.estimated_delivery.to_i - Time.now.to_i) < 86400
				#Queue expireation
				Resque.enqueue_at(reward.estimated_delivery, Reward::DeliverydueReward, reward.id)
				#Record expiration
				reward.update(
					estimated_delivery_expiration_queued: true,
					estimated_delivery_expiration_queued_at: Time.now
				)
			end
		end
	end

end