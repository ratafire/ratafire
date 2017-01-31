class Test::Scheduler

	@queue = :test

	def self.perform
		puts "This is a test resque scheduler job"
	end

end