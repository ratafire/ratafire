class Subscription::SubscriptionConfirmation
	#Send confirmation to subscribers
	@queue = :subscription

	def self.perform
	end

end