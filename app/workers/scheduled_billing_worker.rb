class ScheduledBillingWorker

	@queue = :scheduled_billing_queue

	def self.perform
		BillingSubscription.where(activated: true).all.each do |billing|
			@subscriber = User.find(billing.user_id)
			#Find the subscriber's subscriptions, and add up ordered amount
			@subscriber.subscriptions.each do |subscription|
				@subscribed = User.find(subscription.subscribed_id)
				if @subscribed != nil then
					#Check if the subscribed has updated in last month
					#Check if the subscribed updated Facebook Page
					if @subscribed.facebookupdates.first != nil then
						if @subscribed.facebookupdates.first.created_at > ( Time.now - 30.days ) then
							#Create or find a transfer
							if @subscribed.transfer != nil then
								@transfer = @subscribed.transfer
							else
								@transfer = Transfer.new
								@transfer.user_id = @subscribed.id
								@transfer.billing_artist_id = @subscribed.billing_artist.id
								@transfer.recipient_id = @subscribed.recipient.id
								@transfer.ordered_amount += subscription.amount
								@transfer.method = "Stripe"
								@transfer.stripe_recipient_id = @subscribed.recipient.recipient_id
								@transfer.save			
							end		
							#Create or find an order
							if @subscriber.order != nil then
								@order = @subscriber.order
							else
								@order = Order.new
								@order.user_id = @subscriber.id
								@order.amount += subscription.amount
								@order.save
							end
						else
							#Check if the subscribed updated majorposts
							if @subscribed.majorposts.first != nil then
								if @subscribed.majorposts.first.created_at > ( Time.now - 30.days ) then
									#Create or find a transfer
									if @subscribed.transfer != nil then
										@transfer = @subscribed.transfer
									else
										@transfer = Transfer.new
										@transfer.user_id = @subscribed.id
										@transfer.billing_artist_id = @subscribed.billing_artist.id
										@transfer.recipient_id = @subscribed.recipient.id
										@transfer.ordered_amount += subscription.amount
										@transfer.method = "Stripe"
										@transfer.stripe_recipient_id = @subscribed.recipient.recipient_id
										@transfer.save			
									end		
									#Create or find an order
									if @subscriber.order != nil then
										@order = @subscriber.order
									else
										@order = Order.new
										@order.user_id = @subscriber.id
										@order.amount += subscription.amount
										@order.save
									end
								else
									#check if the subscribed has a new project
									if @subscribed.projects.where("published_at IS NOT NULL").first != nil then
										if @subscribed.projects.where("published_at IS NOT NULL").first.published_at > ( Time.now - 30.days ) then
											#Create or find a transfer
											if @subscribed.transfer != nil then
												@transfer = @subscribed.transfer
											else
												@transfer = Transfer.new
												@transfer.user_id = @subscribed.id
												@transfer.billing_artist_id = @subscribed.billing_artist.id
												@transfer.recipient_id = @subscribed.recipient.id
												@transfer.ordered_amount += subscription.amount
												@transfer.method = "Stripe"
												@transfer.stripe_recipient_id = @subscribed.recipient.recipient_id
												@transfer.save			
											end		
											#Create or find an order
											if @subscriber.order != nil then
												@order = @subscriber.order
											else
												@order = Order.new
												@order.user_id = @subscriber.id
												@order.amount += subscription.amount
												@order.save
											end
										else
											 #check if the subscribed has a new discussion
											 if @subscribed.discussions.where(:review_status => "Approved").first != nil then
											 	if @subscribed.discussions.where(:review_status => "Approved").first.created_at > ( Time.now - 30.days ) then
													#Create or find a transfer
													if @subscribed.transfer != nil then
														@transfer = @subscribed.transfer
													else
														@transfer = Transfer.new
														@transfer.user_id = @subscribed.id
														@transfer.billing_artist_id = @subscribed.billing_artist.id
														@transfer.recipient_id = @subscribed.recipient.id
														@transfer.ordered_amount += subscription.amount
														@transfer.method = "Stripe"
														@transfer.stripe_recipient_id = @subscribed.recipient.recipient_id
														@transfer.save			
													end		
													#Create or find an order
													if @subscriber.order != nil then
														@order = @subscriber.order
													else
														@order = Order.new
														@order.user_id = @subscriber.id
														@order.amount += subscription.amount
														@order.save
													end
											 	else
											 		#The subscribed has not updated
											 		@subscribed.update_column(:subscription_inactive, true)
											 		#send an email to the inactive account to ask the user to update
											 	end
											 end
										end
									end
								end
							end
						end
					end
				end
			end#@subscriber.subscriptions.each do |subscription|
			#Swipe the card for the ordered amount
			
		end#BillingSubscription.where(activated: true).all.each do |billing|
	end#self.perform

end#ScheduledBillingWorker