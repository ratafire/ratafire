class Achievement::SubscriptionsCreate

	@queue = :achievement

	def self.perform(subscription_id)
		if @subscription = Subscription.find(subscription_id)
			if @user = User.find(@subscription.subscribed_id)
				#Subscribers count series
				unless @user.achievements.where(name: "First Drop of Water").any?
					Resque.enqueue(Achievement::Counter, "First Drop of Water", @subscription.subscribed_id, 1) #10
				end
				unless @user.achievements.where(name: "First Rain").any?
					Resque.enqueue(Achievement::Counter, "First Rain", @subscription.subscribed_id, 1) #50
				end
				unless @user.achievements.where(name: "Second Rain").any?
					Resque.enqueue(Achievement::Counter, "Second Rain", @subscription.subscribed_id, 1) #100
				end
				unless @user.achievements.where(name: "Power of The Waves").any?
					Resque.enqueue(Achievement::Counter, "Power of The Waves", @subscription.subscribed_id, 1) #500
				end
				#A Hazelnut a Day Keeps The Doctor Away
				unless @user.achievements.where(name: "A Hazelnut a Day Keeps The Doctor Away").any?
					Resque.enqueue(Achievement::Daily, "A Hazelnut a Day Keeps The Doctor Away", @subscription.subscribed_id, 1) #500
				end
			end
		end
	end	

end