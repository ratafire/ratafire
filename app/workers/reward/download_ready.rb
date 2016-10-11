class Reward::DownloadReady

	#Charge the subscriber
	@queue = :reward

	def self.perform(reward_id)
		@reward = Reward.find(reward_id)
		@reward.reward_receivers.where(paid: true).each do |reward_receiver|
			#Update reward receiver statuscdf
			reward_receiver.update(
				status: 'ready_to_download'
			)
			#Send email
			Payment::ShippingOrdersMailer.ready_to_download(reward_receiver_id: reward_receiver.id).deliver_now
			#Send notification
			Notification.create(
				user_id: reward_receiver.user_id,
	            trackable_id: reward_receiver.id,
	            trackable_type: "RewardReceiver",
	            notification_type: "ready_to_download"
			)
		end
	end

end