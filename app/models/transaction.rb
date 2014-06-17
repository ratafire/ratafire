class Transaction < ActiveRecord::Base
  	# attr_accessible :title, :body
	  belongs_to :subscription_records
  	before_validation :generate_uuid!, :on => :create
  	self.primary_key = 'uuid'
    

  	#This is where we create our Caller Reference for Amazon Payments, and prefill some other information
  	def self.prefill!(options = {})
  		@transaction = Transaction.new
  		@subscription = Subscription.find(options[:subscription_id])
  		@transaction.amount = @subscription.amount.to_s
      @transaction.supporter_switch = @subscription.supporter_switch
  		case @transaction.amount
  		when ENV["PRICE_1"]
  			@transaction.ratafire = 6
  		when ENV["PRICE_2"]
  			@transaction.ratafire = 3
  		when ENV["PRICE_3"]
  			@transaction.ratafire = 6
  		when ENV["PRICE_4"]
  			@transaction.ratafire = 6
  		when ENV["PRICE_5"]
  			@transaction.ratafire = 9
  		when ENV["PRICE_6"]
  			@transaction.ratafire = 9
  		end	
      @transaction.supporter_switch = @subscription.supporter_switch
  		@transaction.subscribed_id = @subscription.subscribed_id
      @transaction.subscriber_id = @subscription.subscriber_id
      @transaction.SenderTokenId = @subscription.amazon_recurring.tokenID
  		@transaction.RecipientTokenId = @subscription.amazon_recurring.recipientToken
  		@transaction.subscription_record_id = @subscription.subscription_record_id
  		@transaction.save
  		@transaction
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
