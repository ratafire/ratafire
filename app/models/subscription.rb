class Subscription < ActiveRecord::Base

    #----------------Utilities----------------

    #Default scope
	default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create	

    #--------Track activities--------
	include PublicActivity::Model
	tracked except: [:create, :update, :destroy], owner: ->(controller, model) { controller && controller.current_user }  

    #----------------Relationships----------------
    #Belongs to
	belongs_to :subscriber, class_name: "User"
	belongs_to :subscribed, class_name: "User"
	belongs_to :subscription_record

	belongs_to :supporter, class_name: "User"
	belongs_to :supported, class_name: "User"

	belongs_to :subscribed_organization, class_name: "Organization"

	belongs_to :campaign
	belongs_to :majorpost

	#Has many
	has_many :reward_receivers,
		-> { where(reward_receivers:{:deleted => nil })}
    accepts_nested_attributes_for :reward_receivers, limit: 1, :allow_destroy => true

    has_many :cards
    accepts_nested_attributes_for :cards, limit: 1, :allow_destroy => true

    has_many :shipping_addresses
    accepts_nested_attributes_for :shipping_addresses, limit: 1, :allow_destroy => true

    has_many :disputes

	#has_one :amazon_recurring

	#Reasons a subscription stopped
	#1. Subscriber unsubscribed
	#2. Subscribed removed the subscriber
	#3. Subscriber failed to make payments
	#4. Subscribed failed to maintain status
	#5. Subscribed deactivated account
	#6. Subscriber deactivated account
	#7. Subscribed changed payments account
	#8. This is a one time payment

	#8. Supported remove the supporter
	#9. Supporter unsupported
	#10. Did not pass the 3 supporters test

    #----------------Validations----------------

	#subscriber
	validates_presence_of :subscriber_id

	#subscribed
	validates_presence_of :subscribed_id

	#amount
	validates :amount, :presence => true, inclusion: 1..200


    #----------------Methods----------------

    #--------Create order--------
 	
 	def self.create_order(subscription_id)
 		#Load models
 		@subscription = Subscription.find(subscription_id)
 		@subscribed = @subscription.subscribed
 		@subscriber = @subscription.subscriber
 		#Check if the subscribed updated a majorpost
 		if @subscribed.unpaid_updates.count > 0 && @subscribed.active_campaign
	 		if @subscribed.unpaid_updates.first.try(:published_at) > ( Time.now - 1.month ) && @subscribed.active_campaign
	 			@subscribed.update(
	 				subscription_inactive: nil,
	 				subscription_inactive_at: nil
	 			)
	 			#Subscriber pays the subscribed per creation
	 			if @subscribed.active_campaign.funding_type == 'creation'
	 				if @subscribed.unpaid_updates.count > @subscription.upper_limit
	 					@creation_count = @subscription.upper_limit.to_i
	 				else
	 					@creation_count = @subscribed.unpaid_updates.count.to_i
	 				end
	 				#Create order
	 				if @subscriber.order 
	 					@order = @subscriber.order
	 					if @order.update(
	 						amount: @order.amount + @subscription.amount*@creation_count,
	 						count: @order.count + 1
	 						)
		 					#Create order subset
		 					@order_subset = OrderSubset.create(
		 						order_id: @order.id,
		 						amount: @subscription.amount*@creation_count,
		 						subscribed_id: @subscription.subscribed.id,
		 						subscriber_id: @subscription.subscriber.id,
		 						subscription_id: @subscription.id,
		 						currency: @subscription.currency,
		 						description: I18n.t('mailer.payment.subscription.receipt.support')+@subscription.subscribed.preferred_name,
		 						updates: @creation_count
		 					)
		 				end
	 				else
	 					if @order = Order.create(
	 						user_id: @subscriber.id,
	 						amount: @subscription.amount*@creation_count,
	 						count: 1,
	 						currency: @subscription.currency
	 						)
		 					#Create order subset
		 					@order_subset = OrderSubset.create(
		 						order_id: @order.id,
		 						amount: @subscription.amount*@creation_count,
		 						subscribed_id: @subscription.subscribed.id,
		 						subscriber_id: @subscription.subscriber.id,
		 						subscription_id: @subscription.id,
		 						currency: @subscription.currency,
		 						description: I18n.t('mailer.payment.subscription.receipt.support')+@subscription.subscribed.preferred_name,
		 						updates: @subscribed.unpaid_updates.count
		 					)
	 					end
	 				end
	 			else
	 				#Subscriber pays the subscribed per month
	 				if @subscription.funding_type == 'month'
	 					#Create order
		 				if @subscriber.order 
		 					@order = @subscriber.order
		 					if @order.update(
		 						amount: @order.amount + @subscription.amount,
		 						count: @order.count + 1
		 						)
			 					#Create order subset
			 					@order_subset = OrderSubset.create(
			 						order_id: @order.id,
			 						amount: @subscription.amount,
			 						subscribed_id: @subscription.subscribed.id,
			 						subscriber_id: @subscription.subscriber.id,
			 						subscription_id: @subscription.id,
			 						currency: @subscription.currency,
			 					)
			 				end
		 				else
		 					if @order = Order.create(
		 						user_id: @subscriber.id,
		 						amount: @subscription.amount,
		 						count: 1
		 						)
			 					#Create order subset
			 					@order_subset = OrderSubset.create(
			 						order_id: @order.id,
			 						amount: @subscription.amount,
			 						subscribed_id: @subscription.subscribed.id,
			 						subscriber_id: @subscription.subscriber.id,
			 						subscription_id: @subscription.id,
			 						currency: @subscription.currency,
			 					)
		 					end
		 				end
	 				end
	 			end
	 		else
	 			@subscribed.update(
	 				subscription_inactive: true,
	 				subscription_inactive_at: Time.now
	 			)
	 		end
	 	else
 			@subscribed.update(
 				subscription_inactive: true,
 				subscription_inactive_at: Time.now
 			)
	 	end
	rescue
 	end

 	#--------Unsubscribe--------

 	def self.unsubscribe(options = {})
 		@reason_number = options[:reason_number]
 		if @subscription = Subscription.find_by_subscriber_id_and_subscribed_id(options[:subscriber_id],options[:subscribed_id])
	 		@subscriber = @subscription.subscriber
	 		@subscribed = @subscription.subscribed

	 		#update subscription
			@subscription.update(
				deleted_reason: @reason_number,
				deleted: true,
				deleted_at: Time.now
			)
			#update subscription_record
			if @subscription_record = SubscriptionRecord.find_by_subscriber_id_and_subscribed_id(@subscription.subscriber_id,@subscription.subscribed_id)
				unless @subscription.funding_type == 'one_time'
					#Real deletion
					@subscription.update(
						real_deleted: true
					)
					if @subscription_record.duration == nil then
						@subscription_record.duration = @subscription.deleted_at - @subscription.created_at
					else
						duration = @subscription.deleted_at - @subscription.created_at
						@subscription_record.duration = @subscription_record.duration + duration
					end	
					valid_subscription = ((@subscription.deleted_at - @subscription.created_at)/1.day).to_i
					if valid_subscription < 30 then
						#Delete activity
						PublicActivity::Activity.where(trackable_id: @subscription.id,trackable_type:'Subscription').each do |activity|
							if activity != nil then 
								activity.update(
									deleted: true,
									deleted_at: Time.now,
								)
							end
						end
						#Delete notification
						if Notification.where(trackable_id: @subscription.id)
							Notification.where(trackable_id: @subscription.id).all.each do |notification|
								notification.update(
									deleted: true,
									deleted_at: Time.now
								)
							end
						end
					end
					if @subscription.reward_receivers
						@subscription.reward_receivers.where(:paid => false, :deleted => nil).each do |reward_receiver|
							reward_receiver.update(
								deleted: true,
								deleted_at: Time.now
							)
						end
					end
					#Subtract the predicted for long term backers
					@subscription.campaign.update(
						predicted_total: @subscription.campaign.predicted_total-@subscription.amount,
						recurring_total: @subscription.campaign.recurring_total-@subscription.amount
					)
					#Update latest paid update
					if @subscription.majorpost
						@subscription.majorpost.update(
							predicted_total: @subscription.majorpost.predicted_total-@subscription.amount,
							recurring_total: @subscription.majorpost.recurring_total-@subscription.amount
						)
					end
					#Update rewards
					if @subscribed.active_reward
						@subscribed.active_reward.update(
							predicted_total: @subscribed.active_reward.predicted_total-@subscription.amount,
							recurring_total: @subscribed.active_reward.recurring_total-@subscription.amount
						)
					end
				end
				@subscription_record.update(
					past: true
				)
			end
			#clear billing subscription
			if @billing_subscription = @subscriber.billing_subscription
				@billing_subscription.next_amount = @billing_subscription.next_amount - @subscription.amount
				unless @subscriber.subscriptions.any? then
					@billing_subscription.activated = false
				end
				@billing_subscription.save
			end	
			# if @billing_artist = @subscribed.billing_artist
			# 	@billing_artist.predicted_next_amount -= @subscription.amount
			# 	@billing_artist.save
			# end
			#Remove order if any
			if @order = @subscriber.order
				if @order_subset = @subscriber.order.try(:order_subsets).where(order_id: @order.id,subscribed_id: @subscription.subscribed.id, transacted: nil, deleted: nil).first
					@order_subset.update(
						deleted: true,
						deleted_at: Time.now
					)
					@order.update(
						amount: @order.amount-@order_subset.amount,
						count: @order.count-1
					)
					if @order.amount == 0
						@order.update(
							deleted: true,
							deleted_at: Time.now
						)
					end
				end
			end	
		end
 	end

 	def self.unsubscribe_failed_payment(options = {})
 	end

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Subscription.find_by_uuid(self.uuid).present?
    end
end
