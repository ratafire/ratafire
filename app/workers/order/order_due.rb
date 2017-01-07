class Order::OrderDue

	#Send confirmation to subscribers
	@queue = :order

	def self.perform
		Order.where(transacted: nil).all.each do |order|
			@subscriber = User.find(order.user_id)
			order.order_subsets.each do |order_subset|
				@subscribed = User.find(order_subset.subscribed_id)
				order_subset.update(
					status: 'Error',
					deleted: true,
					deleted_at: Time.now
				)
				Subscription.unsubscribe(reason_number: 3, subscriber_id:@subscriber.id, subscribed_id: @subscribed.id)
			end
			order.update(
				deleted: true,
				deleted_at: Time.now,
				status: "Unpaid"
			)
		end
	end

end