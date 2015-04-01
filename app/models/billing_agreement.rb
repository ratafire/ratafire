class BillingAgreement < ActiveRecord::Base
	# attr_accessible :title, :body
	before_validation :generate_uuid!, :on => :create
	belongs_to :user
	self.primary_key = 'uuid'

	#This is where we create our billing agreement for paypal
	def self.prefill!(options = {})
  		@billing_agreement = BillingAgreement.new
  		@billing_agreement.user_id = options[:user_id]
  		@billing_agreement.billing_agreement_id = options[:billing_agreement_id]
  		@billing_agreement.save
  		@billing_agreement
	end

	#After authenticating with PayPal, we get the rest of the details
	def self.postfill!(options = {})	
		@billing_agreement = BillingAgreement.find_by_uuid(options[:uuid])
		#@billing_agreement.billing_agreement_id = #
		if @billing_agreement.billing_agreement_id.present? then
			#@billing_agreement.status = #
		end
		@billing_agreement.save
		@billing_agreement
	end

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while BillingAgreement.find_by_uuid(self.uuid).present?
	end

end
