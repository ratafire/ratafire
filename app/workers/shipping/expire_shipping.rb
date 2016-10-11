class Shipping::ExpireShipping

	#Expire due shipping order
	@queue = :shipping

	def self.perform(shipping_order_id)
		if @shipping_order = ShippingOrder.find(shipping_order_id)
			#Expire this shipping order
			@shipping_order.update(
				expired: true,
				expired_at: Time.now
			)
			#Cancel reward receiver
			RewardReceiver.cancel_payment(@shipping_order.reward_receiver_id)
		end
	end

end