class Achievement::SubscriberCreate

	@queue = :achievement

	def self.perform(subscriber_id)
		if @user = User.find(subscriber_id)
			#Different creators count
			@different_creators = @user.reverse_subscription_records.count
			@accumulated_total = SubscriptionRecord.where(subscriber_id: @user.id).sum(:accumulated_total)
			if @different_creators >= 2
				unless @user.achievements.where(name: "Basic Backer").any?
					if @accumulated_total >= 10
						Resque.enqueue(Achievement::Create, "Basic Backer", @user.id)
					end
				end
			end
			if @different_creators >= 3
				unless @user.achievements.where(name: "Ratafire Apprentice").any?
					Resque.enqueue(Achievement::Setcounter, "Ratafire Apprentice", subscriber_id, @different_creators) #10
				end
				unless @user.achievements.where(name: "Rare Backer").any?
					if @accumulated_total >= 20
						Resque.enqueue(Achievement::Create, "Rare Backer", @user.id)
					end
				end
			end
			if @different_creators >= 5
				unless @user.achievements.where(name: "Ratafire Journeyman").any?
					Resque.enqueue(Achievement::Setcounter, "Ratafire Journeyman", subscriber_id, @different_creators)
				end
				unless @user.achievements.where(name: "Heroic Backer").any?
					if @accumulated_total >= 40
						Resque.enqueue(Achievement::Create, "Heroic Backer", @user.id)
					end
				end
			end
			if @different_creators >= 10
				unless @user.achievements.where(name: "Ratafire Adventurer").any?
					Resque.enqueue(Achievement::Setcounter, "Ratafire Adventurer", subscriber_id, @different_creators)
				end
				unless @user.achievements.where(name: "Epic Backer").any?
					if @accumulated_total >= 80
						Resque.enqueue(Achievement::Create, "Epic Backer", @user.id)
					end
				end
			end
			if @different_creators >= 20
				unless @user.achievements.where(name: "Ratafire Expert").any?
					Resque.enqueue(Achievement::Setcounter, "Ratafire Expert", subscriber_id, @different_creators)
				end
				unless @user.achievements.where(name: "Legendary Backer").any?
					if @accumulated_total >= 160
						Resque.enqueue(Achievement::Create, "Legendary Backer", @user.id)
					end
				end
			end
			if @different_creators >= 40
				unless @user.achievements.where(name: "Mythic Backer").any?
					if @accumulated_total >= 300
						Resque.enqueue(Achievement::Create, "Mythic Backer", @user.id)
					end
				end
			end
			if @different_creators >= 50
				unless @user.achievements.where(name: "Ratafire Hero").any?
					Resque.enqueue(Achievement::Setcounter, "Ratafire Hero", subscriber_id, @different_creators)
				end
			end
			if @different_creators >= 100
				unless @user.achievements.where(name: "Ratafire Master").any?
					Resque.enqueue(Achievement::Setcounter, "Ratafire Master", subscriber_id, @different_creators)
				end
			end
			if @different_creators >= 200
				unless @user.achievements.where(name: "Ratafire Grand Master").any?
					Resque.enqueue(Achievement::Setcounter, "Ratafire Grand Master", subscriber_id, @different_creators)
				end
			end
			if @different_creators >= 300
				unless @user.achievements.where(name: "Ratafire Legend").any?
					Resque.enqueue(Achievement::Setcounter, "Ratafire Legend", subscriber_id, @different_creators)
				end
			end
		end
	end	
end