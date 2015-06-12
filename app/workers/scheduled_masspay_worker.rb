class ScheduledMasspayWorker

	@queue = :scheduled_masspay_queue

	def self.perform
		#Get rid of transfers that don't have paypal account
		Transfer.clean_paypal_account
		#Make Mass Pay Batches
		MasspayBatch.create_masspay_batches
		#Perform Mass Pay
		MasspayBatch.perform_masspay
	end

end