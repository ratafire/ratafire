class Subscription::SubscriptionConfirmation
	#Send confirmation to subscribers
	@queue = :subscription

	def self.perform
		#Create order
		BillingSubscription.where(activated: true).all.each do |billing|
			#Create orders
			begin
				if @subscriber = User.find(billing.user_id)
					@subscriber.reverse_subscriptions.each do |subscription|
						Subscription.create_order(subscription.id)
					end
					#Send out order confirmation
					if @subscriber.order != nil
						if @subscriber.order.amount != 0
							Order.send_confirmation(@subscriber.order.id,@subscriber.id)
						end
					end
				end
			rescue
				#Create subscription error
			end
		end
	end

end