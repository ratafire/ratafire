class Achievement::BackLess

	@queue = :achievement

	def self.perform(subscriber_id, subscription_id)
		if @user = User.find(subscriber_id)
			if @subscription = Subscription.find(subscription_id)
				@subscribed = User.find(@subscription.subscribed_id)
				@followers = @subscribed.likers.count
				if @followers < 100
					unless @user.achievements.where(name: "Arrow to The Heart").any?
						Resque.enqueue(Achievement::Counter, "Arrow to The Heart", subscriber_id, 1) #10
					end
					unless @user.achievements.where(name: "Arrow to The Mark").any?
						Resque.enqueue(Achievement::Counter, "Arrow to The Mark", subscriber_id, 1)
					end
					unless @user.achievements.where(name: "Arrow to The Dream").any?
						Resque.enqueue(Achievement::Counter, "Arrow to The Dream", subscriber_id, 1)
					end
					unless @user.achievements.where(name: "Arrow to The Knee").any?
						Resque.enqueue(Achievement::Counter, "Arrow to The Knee", subscriber_id, 1)
					end
				end
			end
		end
	end

end