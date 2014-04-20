class AmazonRecurring < ActiveRecord::Base
  	# attr_accessible :title, :body
 	 before_validation :generate_uuid!, :on => :create
 	 belongs_to :subscription
 	 self.primary_key = 'uuid'

 	 #This is where we create our Caller Reference for Amazon Payments, and prefill some other information
 	 def self.prefill!(options = {})
 	 	@amazon_recurring = AmazonRecurring.new
 	 	@amazon_recurring.subscription_id = options[:subscription_id]
 	 	@amazon_recurring.transactionAmount = options[:transactionAmount]
 	 	@amazon_recurring.recurringPeriod = "1 month"
 	 	@amazon_recurring.recipientToken = options[:recipientToken]

 	 	#year = Time.now.year.to_i
		#month = Time.now.month.to_i
		#if no change of year
		#if month < 12 then
		#	month = month + 1
		#else
		#	year = year + 1
		#	month = 1
		#end
		#day = 1
		#date = DateTime.new(year,month,day)

 	 	#@amazon_recurring.validityStart = date
 	 	@amazon_recurring.save
 	 	@amazon_recurring
 	 end

 	 #After authenicating with Amazon, we get the rest of the details
 	 def self.postfill!(options = {})
 	 	@amazon_recurring = AmazonRecurring.find_by_uuid(options[:callerReference])
 	 	@amazon_recurring.tokenID = options[:tokenID]
 	 	if @amazon_recurring.tokenID.present? then
 	 		@amazon_recurring.status = options[:status]
 	 		@amazon_recurring.addressName = options[:addressName]
 	 		@amazon_recurring.addressLine1 = options[:addressLine1]
 	 		@amazon_recurring.addressLine2 = options[:addressLine2]
 	 		@amazon_recurring.city = options[:city]
 	 		@amazon_recurring.state = options[:state]
 	 		@amazon_recurring.zip = options[:zip]
 	 		@amazon_recurring.phoneNumber = options[:phoneNumber]
 	 		@amazon_recurring.country = options[:country]
 	 		@amazon_status = options[:status]
 	 		@amazon_recurring.save

 	 		@amazon_recurring
 	 	end
 	 end

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while AmazonRecurring.find_by_uuid(self.uuid).present?
	end

	#Get the datetime of the first day of next month
	def first_day_of_next_month
		year = Time.now.year.to_i
		month = Time.now.month.to_i
		#if no change of year
		if month < 12 then
			month = month + 1
		else
			year = year + 1
			month = 1
		end
		day = 1
		return date = DateTime.new(year,month,day)
	end
end
