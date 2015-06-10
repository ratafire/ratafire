class ScheduledTransferAmountWorker

	@queue = :scheduled_transfer_amount_queue

	def self.perform
		if Transfer.where(transfered: nil, on_hold: nil).any? then
			@amount = 0
			Transfer.where(transfered: nil, on_hold: nil).all.each do |transfer|
				@amount += transfer.collected_receive
				#Tell the admin about the amount
			end
			@api = PayPal::SDK::Merchant::API.new
			@get_balance = @api.build_get_balance({:ReturnAllCurrencies => "0" })
			@get_balance_response = @api.get_balance(@get_balance)
			@still_short_amout = @amount - @get_balance_response.Balance.value.to_f 
			SubscriptionMailer.transfer_admin_emails(5, :transfer_amount => @amount, :still_needed_amount => @still_short_amout ).deliver	
		end
	end

end