class ScheduledUsernameGeneratorWorker

	@queue = :scheduled_username_generator_queue

	def self.perform
		User.where(:username => nil).all.each do |user|
			begin
				user.username = user.fullname.downcase.gsub(/\W/, '')
				if User.find_by_username(user.username).present?
					begin
						if user.fullname != nil then
							user.username = user.fullname.downcase.gsub(/\W/, '') + SecureRandom.hex(5)
						else
							user.username = SecureRandom.hex(10)
						end
					end while User.find_by_username(user.username).present?
					user.save
				else
					user.save
				end
			rescue
				#Something to notice the admin
			end
		end
	end

end