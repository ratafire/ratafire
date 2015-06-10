class ScheduledMasspayWorker

	@queue = :scheduled_masspay_queue

	def self.perform
		#Make Mass Pay Batches
		MasspayBatch.create_masspay_batches
		#Perform Mass Pay
		MasspayBatch.perform_masspay
	end

end