class Transaction < ActiveRecord::Base

    #----------------Utilities----------------

    #Default scope
    default_scope  { order(:created_at => :desc) } 

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Methods----------------

    def self.prefill!(response,options = {})
		@transaction = Transaction.new
		if @transaction.total == nil
			@transaction.total = response.amount.to_f/100
			@transaction.fee = options[:fee]
		else
			@transaction.total += response.amount.to_f/100
			@transaction.fee += options[:fee]
		end
		@transaction.receive = response.amount.to_f/100 - options[:fee]
		@transaction.subscriber_id = options[:subscriber_id]
		@transaction.subscribed_id = options[:subscribed_id]
		@transaction.order_id = options[:order_id]
		@transaction.shipping_order_id = options[:shipping_order_id]
		@transaction.reward_id = options[:reward_id]
		@transaction.transaction_type = options[:transaction_type]
		@transaction.currency = options[:currency]
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
		@transaction.failure_code = response.failure_code
		@transaction.failure_message = response.failure_message
		@transaction.save
		@transaction.method = options[:transaction_method]
		@transaction.fee = options[:fee].to_f
		@transaction.receive = @transaction.total - @transaction.fee
		return @transaction
    end

    def self.failed_transaction(response)
    	#Update transaction
    	if @transaction = Transaction.find_by_stripe_id(response.id)
    		#Set the transaction as failed
    		@transaction.update(
    			status: response.status,
    			failure_code: response.failure_code,
    			failure_message: response.failure_message
    		)
    		@transaction.transaction_subsets.all.each do |transaction_subset|
    			transaction_subset.update(
    				deleted: true,
    				deleted_at: Time.now
    			)
    		end
    		#Specific cases
    		case @transaction.transaction_type
    		#One time payment
	    	when 'Back'
	    		#Unsubscribe
	    		Subscription.unsubscribe_failed_payment(reason_number: 3, subscription_id: @transaction.subscription_id)
	    	#Long term payment
	    	when 'Subscription'
	    		#Find order
	    		@order_subset = OrderSubset.find(@transaction.order_subset_id)
	    		@order_subset.update(
	    			status: 'failed'
	    		)
	    		Subscription.unsubscribe_failed_payment(reason_number: 3, subscription_id: @order_subset.subscription_id)
	    	#Shipping fee
	    	when 'Shipping'
	    		ShippingOrder.transaction_failed(@transaction.shipping_order_id)
	    	end
    	end
    end

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
    belongs_to :subscriber, class_name: "User"
    belongs_to :order

    #Has many
    has_many :transaction_subsets, :foreign_key => 'transaction_id', class_name: "TransactionSubset"

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(8)
        end while Transaction.find_by_uuid(self.uuid).present?
    end

end