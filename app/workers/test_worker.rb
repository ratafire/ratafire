class TestWorker
	@queue = :test_queue

	def self.perform
		test = 1+1
		self.privatework
	end

private

	def self.privatework
		test = 2+1
	end	
end