class AmazonRecipient < ActiveRecord::Base
	 # attr_accessible :title, :body
 	 before_validation :generate_uuid!, :on => :create
 	 belongs_to :subscription
 	 self.primary_key = 'uuid'

 	 #This is where we create our Caller Reference for Amazon Payments, and prefill some other information.
 	 def self.prefill!(options = {})
 	 	@amazon_recipient = AmazonRecipient.new
 	 	@amazon_recipient.user_id = options[:user_id]
 	 	@amazon_recipient.save
 	 	@amazon_recipient
 	 end

 	 #After authenticating with Amazon, we get the rest of the details
 	 def self.postfill!(options = {})
 	 	@amazon_recipient = AmazonRecipient.find_by_uuid(options[:callerReference])
 	 	@amazon_recipient.tokenID = options[:tokenID]
 	 	if @amazon_recipient.tokenID.present? then
 	 		@amazon_recipient.Status = options[:status]
 	 	end
 	 	@amazon_recipient.save
 	 	@amazon_recipient
 	 end

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while AmazonRecipient.find_by_uuid(self.uuid).present?
	end

end
