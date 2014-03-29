class TransactionWorker
	@queue = :transactions_queue
	def self.perform(id)
		transaction = Transaction.prefill!(:subscription_id => s.id)
		begin
			response = AmazonFlexPay.pay(s.amount.to_s, 'USD', transaction.SenderTokenId, transaction.uuid,
						:marketplace_fixed_fee => { :value => transaction.ratafire.to_s, :currency_code => 'USD'})
		rescue AmazonFlexPay::API::Error => e
			#some notification
		end
	end
end