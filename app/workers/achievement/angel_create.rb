class Achievement::AngelCreate

	@queue = :achievement

	def self.perform(subscriber_id, subscription_record_id)
		if @user = User.find(subscriber_id)
			if @subscription_record = SubscriptionRecord.find(subscription_record_id)
				@different_creators = @user.reverse_subscription_records.where(first_blood: true).count
				@accumulated_total = SubscriptionRecord.where(subscriber_id: @user.id, first_blood: true).sum(:accumulated_total)
				if @different_creators >= 1
					unless @user.achievements.where(name: "Angel").any?
						Resque.enqueue(Achievement::Counter, "Angel", subscriber_id, 1)
					end
				end
				if @different_creators >= 5
					if @accumulated_total >= 10
						unless @user.achievements.where(name: "Aqua Angel").any?
							Resque.enqueue(Achievement::Create, "Aqua Angel", @user.id)
						end
					end
				end
				if @different_creators >= 10
					if @accumulated_total >= 50
						unless @user.achievements.where(name: "Flame Angel").any?
							Resque.enqueue(Achievement::Create, "Flame Angel", @user.id)
						end
					end
				end
				if @different_creators >= 50
					if @accumulated_total >= 250
						unless @user.achievements.where(name: "Seraph").any?
							Resque.enqueue(Achievement::Create, "Seraph", @user.id)
						end
					end
				end
				if @different_creators >= 100
					if @accumulated_total >= 1000
						unless @user.achievements.where(name: "Archangel").any?
							Resque.enqueue(Achievement::Create, "Archangel", @user.id)
						end
					end
				end
			end
		end
	end

end