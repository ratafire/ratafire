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
		@transaction.save
		@transaction.method = options[:transaction_method]
		@transaction.fee = options[:fee].to_f
		@transaction.receive = @transaction.total - @transaction.fee
		return @transaction
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