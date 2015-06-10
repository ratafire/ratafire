class Transaction < ActiveRecord::Base
	# attr_accessible :title, :body
	  belongs_to :subscription_records
	before_validation :generate_uuid!, :on => :create
	#self.primary_key = 'uuid'

	#This is the prefill for the first transaction of a subscription
	def self.prefill!(response,options = {})
		@transaction = Transaction.new
		@transaction.total = response.amount.to_f/100
		@transaction.fee = options[:fee]
		@transaction.receive = response.amount.to_f/100 - options[:fee]
		@transaction.supporter_switch = options[:supporter_switch]
		@transaction.subscriber_id = options[:subscriber_id]
		@transaction.subscribed_id = options[:subscribed_id]
		@transaction.subscription_id = options[:subscription_id]
		@transaction.stripe_id = response.id
		if response.status == "succeeded" then
			@transaction.status = "Success"
		else
			@transaction.status = response.status
		end
		@transaction.captured = response.captured
		@transaction.paid = response.paid
		@transaction.customer_stripe_id = response.source.customer 
		@transaction.description = response.description
		@transaction.card_stripe_id = response.source.id
		@transaction.save
		@transaction.method = options[:transaction_method]
		@transaction.fee = options[:fee].to_f
		@transaction.receive = @transaction.total - @transaction.fee
		@transaction
	end

	#This is the prefill for paypal transaction
	def self.paypal!(response,options = {})
		@transaction = Transaction.new
		@transaction.total = response.amount.total
		@transaction.fee = response.amount.fee
		@transaction.receive = @transaction.total - @transaction.fee
		@transaction.method = options[:transaction_method]
		@transaction.supporter_switch = options[:supporter_switch]
		@transaction.subscriber_id = options[:subscriber_id]
		@transaction.subscribed_id = options[:subscribed_id]
		@transaction.subscription_id = options[:subscription_id]		
		@transaction.status = response.ack
		@transaction.paypal_correlation_id = response.correlation_id
		@subscriber = User.find(options[:subscriber_id])
		if @subscriber != nil then
			@transaction.billing_agreement_id = @subscriber.billing_agreement.billing_agreement_id
			@transaction.paypal_transaction_id = response.transaction_id
			@transaction.save
			@transaction	
		else
			#failure
		end	
	end

	#This is the prefill for venmo transaction
	def self.venmo!(response,options = {})
		@transaction = Transaction.new
		@transaction.total = response["data"]["payment"]["amount"]
		#See if there is a fee
		if response["data"]["payment"]["fee"] == nil then
			@transaction.receive = @transaction.total
		else
			@transaction.fee = response["data"]["payment"]["fee"]
			@transaction.receive = @transaction.total - @transaction.fee
		end
		@transaction.method = options[:transaction_method]
		@transaction.supporter_switch = options[:supporter_switch]
		@transaction.subscriber_id = options[:subscriber_id]
		@transaction.subscribed_id = options[:subscribed_id]
		@transaction.subscription_id = options[:subscription_id]
		@transaction.status = response["data"]["payment"]["status"]
		@transaction.venmo_transaction_id = response["data"]["payment"]["id"]
		@transaction.save
		@subscriber = User.find(options[:subscriber_id])
		if @subscriber != nil then
			@transaction.venmo_username = @subscriber.user_venmo.username
			@transaction.venmo_token = @subscriber.user_venmo.token
			@transaction.save
			@transaction		
		else
			#failure
		end
	end
	
	#After authenicating with Amazon, we get the rest of the details
	def self.postfill!(options = {})
		@transaction = Transaction.find_by_uuid(options[:callerReference])
		@transaction.TransactionId = options[:TransactionId]
		@transaction.status = options[:StatusCode]
		if @transaction.TransactionId.present? then
			@transaction.save
			@transaction
		end
	end

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while Transaction.find_by_uuid(self.uuid).present?
	end
end

#Depreciated Amazon Payments
#This is where we create our Caller Reference for Amazon Payments, and prefill some other information
#def self.prefill!(options = {})
#	@transaction = Transaction.new
#	@subscription = Subscription.find(options[:subscription_id])
#	@transaction.amount = @subscription.amount.to_s
#	@transaction.supporter_switch = @subscription.supporter_switch
#	case @transaction.amount
#	when ENV["PRICE_1"]
#		@transaction.ratafire = 6
#	when ENV["PRICE_2"]
#		@transaction.ratafire = 6
#	when ENV["PRICE_3"]
#		@transaction.ratafire = 6
#	when ENV["PRICE_4"]
#		@transaction.ratafire = 6
#	when ENV["PRICE_5"]
#		@transaction.ratafire = 6
#	when ENV["PRICE_6"]
#		@transaction.ratafire = 6
#	end	
#	@transaction.supporter_switch = @subscription.supporter_switch
#	@transaction.subscribed_id = @subscription.subscribed_id
#	@transaction.subscriber_id = @subscription.subscriber_id
#	@transaction.SenderTokenId = @subscription.amazon_recurring.tokenID
#	@transaction.RecipientTokenId = @subscription.amazon_recurring.recipientToken
#	@transaction.subscription_record_id = @subscription.subscription_record_id
#	@transaction.subscription_id = options[:subscription_id]
#	@transaction.save
#	@transaction
#end
