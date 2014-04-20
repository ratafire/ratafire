class TransactionWorker
	@queue = :transactions_queue
	def self.perform(id)
		transaction = Transaction.prefill!(:subscription_id => id)
		begin
			response = AmazonFlexPay.pay(transaction.amount, 'USD', transaction.SenderTokenId, transaction.uuid,
						:marketplace_variable_fee => transaction.ratafire, :recipient_token_id => transaction.RecipientTokenId)
			if response != nil then
				transaction.TransactionId = response.transaction_id
				transaction.save
				if transaction.TransactionId != nil then
					Resque.enqueue_at(1.minute.from_now, TransactionStatusWorker, transaction.TransactionId)
				end
			end
		rescue AmazonFlexPay::API::Error => e
			#some notification
			if e != nil then
				transaction.error = e.to_s
				transaction.save
			end
		end
	end
end