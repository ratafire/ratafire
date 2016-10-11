class Reward::RewardDue

	#Put due reward on queue
	@queue = :reward

	def self.perform
		Reward.where(deleted: nil, expired: nil, expiration_queued: nil).each do |reward|
			#Check if the reward is due
			if (reward.due.to_i - Time.now.to_i) < 86400
				#Queue expiration
				Resque.enqueue_at(reward.due, Reward::ExpireReward, reward.id)
				#Record expiration
				reward.update(
					expiration_queued: true,
					expiration_queued_at: Time.now
				)
			end
		end
	end

end