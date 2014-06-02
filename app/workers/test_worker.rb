class TestWorker
	@queue = :test_queue

	def self.perform
		test = 1+1
		test = 2+1

	end

end