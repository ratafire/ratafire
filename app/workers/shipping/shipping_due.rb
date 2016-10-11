class Shipping::ShippingDue

	#Put due shipping order on queue
	@queue = :shipping

	def self.perform
		ShippingOrder.where(deleted: nil, expired: nil, expiration_queued: nil, transacted: nil).each do |shipping_order|
			#Check if the shipping order is due
			if (shipping_order.due.to_i - Time.now.to_i) < 86400
				#Queue expiration
				Resque.enqueue_at(shipping_order.due, Shipping::ExpireShipping, shipping_order.id)
				#Record expiration
				shipping_order.update(
					expiration_queued: true,
					expiration_queued_at: Time.now
				)
			end
		end
	end

end