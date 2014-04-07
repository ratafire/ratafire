class TransactionWorker
	@queue = :transactions_queue
	def self.perform(id)
		transaction = Transaction.prefill!(:subscription_id => id)
		begin
			response = AmazonFlexPay.pay(transaction.amount.to_s, 'USD', transaction.SenderTokenId, transaction.uuid,
						:marketplace_variable_fee => 9.00, :recipient_token_id => transaction.RecipientTokenId)
		rescue AmazonFlexPay::API::Error => e
			#some notification
		end
	end
end