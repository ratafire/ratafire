class Subscription::Transfer
	#Send confirmation to subscribers
	@queue = :subscription

	def self.perform
		#Clean up orders
		Order.where(transacted:nil,deleted:nil,deleted_at:nil).all.each do |order|
			#Unsubscribe
			if @subscriber = User.find(order.user_id)
				Subscription.where(subscriber_id:@subscriber.id,deleted:false).all.each do |subscription|
					Subscription.unsubscribe(reason_number:3, subscriber_id:subscription.subscriber.id,subscribed_id:subscription.subscribed.id)
				end
				order.update(
					deleted:true,
					deleted_at:Time.now,
					status:'Error'
				)
			end
		end
		#Send transfer
		Transfer.where(transfered: nil, on_hold: nil).all.each do |transfer|
			Transfer.make_transfer(transfer.id)
		end
	end

end