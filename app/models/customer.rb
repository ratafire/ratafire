class Customer < ActiveRecord::Base


    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create    

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
	#Has one
	has_one :card

    def self.prefill!(customer, user_id)
        @customer = Customer.new
        @customer.user_id = user_id
        @customer.customer_id = customer.id
        @customer.object = customer.object
        @customer.livemode = customer.livemode
        @customer.account_balance = customer.account_balance
        @customer.default_source = customer.default_source
        @customer.delinquent = customer.delinquent
        @customer.email = customer.email
        @customer.save
    end    

private

	def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Customer.find_by_uuid(self.uuid).present?
    end

end