class ScheduledRebillingWorker

	@queue = :scheduled_rebilling_queue

	def self.perform
		Order.where(:transacted => nil, :deleted => nil).all.each do |order|
			@subscriber = User.find(order.user_id)
			@order = order
			#Swipe the card for the ordered amount
			if @subscriber.order.amount != 0 then
				Order.transact_order_final(@subscriber.order.id,@subscriber.id)
			end#if @subscriber.order.amount != 0 then
			
		end
	end
end