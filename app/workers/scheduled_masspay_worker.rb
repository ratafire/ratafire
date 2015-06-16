class ScheduledMasspayWorker

	@queue = :scheduled_masspay_queue

	def self.perform
		#Perform Mass Pay
		MasspayBatch.perform_masspay
	end

end