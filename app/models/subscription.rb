class Subscription < ActiveRecord::Base
	#attr_accessible :amount, :subscriber_id, :subscribed_id, :created_at, :supporter, :method

	default_scope order: 'subscriptions.created_at DESC'

	#track activities
	include PublicActivity::Model
	tracked except: [:create, :update, :destroy], owner: ->(controller, model) { controller && controller.current_user }  

	belongs_to :subscriber, class_name: "User"
	belongs_to :subscribed, class_name: "User"
	belongs_to :subscription_record

	belongs_to :supporter, class_name: "User"
	belongs_to :supported, class_name: "User"

	belongs_to :subscribed_organization, class_name: "Organization"

	#has_one :amazon_recurring

  #Reasons a subscription stopped
  #1. Subscriber unsubscribed
  #2. Subscribed removed the subscriber
  #3. Subscriber failed to make payments
  #4. Subscribed failed to maintain status
  #5. Subscribed deactivated account
  #6. Subscriber deactivated account
  #7. Subscribed changed payments account

  #8. Supported remove the supporter
  #9. Supporter unsupported
  #10. Did not pass the 3 supporters test

  #--- Validations ---

	#subscriber
	validates_presence_of :subscriber_id

	#subscribed
	validates_presence_of :subscribed_id

	#amount
	validates_presence_of :amount


 #--- Methods for Transaction ---

 	def self.create_transfer_and_order(subscription_id)

 		subscription = Subscription.find(subscription_id)
		@subscribed = User.find(subscription.subscribed_id)
		@subscriber = User.find(subscription.subscriber_id)
		#Development or Production check
		if Rails.env.production? then
			if subscription.created_at < ( Time.now - 7.days ) then
				@subscription_created_at_checker = true
			else
				@subscription_created_at_checker = false
			end
		else
			@subscription_created_at_checker = true
		end
		#Create Order
		if @subscribed != nil && @subscription_created_at_checker then
			#Check if the subscribed has updated in last month
			#Check if the subscribed updated Facebook Page
			if @subscribed.facebookupdates.first != nil && @subscribed.facebookupdates.first.created_at > ( Time.now - 1.month ) then
				#Create or find a transfer
				unless subscription.method == "Venmo" then
					if @subscribed.transfer != nil then
						@transfer = @subscribed.transfer
						@transfer.ordered_amount += subscription.amount
						@transfer.save	
					else
						@transfer = Transfer.new
						@transfer.user_id = @subscribed.id
						@transfer.billing_artist_id = @subscribed.billing_artist.id
						@transfer.ordered_amount += subscription.amount
						@transfer.method = "PayPal"
						@transfer.save			
					end		
					#Create or find an order
					if @subscriber.order != nil then
						@order = @subscriber.order
						@order.amount += subscription.amount
						@order.count += 1
						@order.save
					else
						@order = Order.new
						@order.user_id = @subscriber.id
						@order.amount += subscription.amount
						@order.count += 1
						@order.save
					end								
				end 	
			else
				#Check if the subscribed updated majorposts
				if @subscribed.majorposts.where("published_at IS NOT NULL").first != nil && @subscribed.majorposts.where("published_at IS NOT NULL").first.published_at > ( Time.now - 1.month ) then
					#Create or find a transfer
					unless subscription.method == "Venmo" then
						if @subscribed.transfer != nil then
							@transfer = @subscribed.transfer
							@transfer.ordered_amount += subscription.amount
							@transfer.save	
						else
							@transfer = Transfer.new
							@transfer.user_id = @subscribed.id
							@transfer.billing_artist_id = @subscribed.billing_artist.id
							@transfer.ordered_amount += subscription.amount
							@transfer.method = "PayPal"
							@transfer.save			
						end		
						#Create or find an order
						if @subscriber.order != nil then
							@order = @subscriber.order
							@order.amount += subscription.amount
							@order.count += 1
							@order.save
						else
							@order = Order.new
							@order.user_id = @subscriber.id
							@order.amount += subscription.amount
							@order.count += 1
							@order.save
						end								
					end 	
				else
					#check if the subscribed has a new project
					if @subscribed.projects.where("published_at IS NOT NULL").first != nil && @subscribed.projects.where("published_at IS NOT NULL").first.published_at > ( Time.now - 1.month )then
						#Create or find a transfer
						unless subscription.method == "Venmo" then
							if @subscribed.transfer != nil then
								@transfer = @subscribed.transfer
								@transfer.ordered_amount += subscription.amount
								@transfer.save	
							else
								@transfer = Transfer.new
								@transfer.user_id = @subscribed.id
								@transfer.billing_artist_id = @subscribed.billing_artist.id
								@transfer.ordered_amount += subscription.amount
								@transfer.method = "PayPal"
								@transfer.save			
							end		
							#Create or find an order
							if @subscriber.order != nil then
								@order = @subscriber.order
								@order.amount += subscription.amount
								@order.count += 1
								@order.save
							else
								@order = Order.new
								@order.user_id = @subscriber.id
								@order.amount += subscription.amount
								@order.count += 1
								@order.save
							end								
						end 	
					else
						 #check if the subscribed has a new discussion
						 if @subscribed.discussions.where(:review_status => "Approved").first != nil && @subscribed.discussions.where(:review_status => "Approved").first.created_at > ( Time.now - 1.month )then
							#Create or find a transfer
							unless subscription.method == "Venmo" then
								if @subscribed.transfer != nil then
									@transfer = @subscribed.transfer
									@transfer.ordered_amount += subscription.amount
									@transfer.save	
								else
									@transfer = Transfer.new
									@transfer.user_id = @subscribed.id
									@transfer.billing_artist_id = @subscribed.billing_artist.id
									@transfer.ordered_amount += subscription.amount
									@transfer.method = "PayPal"
									@transfer.save			
								end		
								#Create or find an order
								if @subscriber.order != nil then
									@order = @subscriber.order
									@order.amount += subscription.amount
									@order.count += 1
									@order.save
								else
									@order = Order.new
									@order.user_id = @subscriber.id
									@order.amount += subscription.amount
									@order.count += 1
									@order.save
								end								
							end 						 
						else
						 	#The subscribed has not updated
						 	@subscribed.update_column(:subscription_inactive, true)
						 	#send an email to the inactive account to ask the user to update
						 	#SubscriptionMailer.fail_to_update(@subscribed.id).deliver
						 end
					end					
				end
			end
		end #if @subscribed != nil && subscription.created_at < ( Time.now - 7.days ) then
 	end


end
