class Transfer < ActiveRecord::Base
	# attr_accessible :title, :body
	belongs_to :user
	default_scope order: 'transfers.created_at DESC'
	before_validation :generate_uuid!, :on => :create
	belongs_to :masspay_batch

	#On hold errors
	#1 No PayPal account
	#2 PayPal account email not in the correct format

	def self.clean_paypal_account
		if Transfer.where(transfered: nil, on_hold: nil, masspay_batch_id: nil).any? then
			Transfer.where(transfered: nil, on_hold: nil, masspay_batch_id: nil).all.each do |transfer|
				#check if the transfer has paypal account
				if transfer.user.paypal_account != nil then
					#Check if the paypal account's email is correct
					if transfer.user.paypal_account.email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i then
					else
						transfer.on_hold = 1
						transfer.error = "PayPal account email incorrect"
						transfer.save
					end
				else
					if transfer.on_hold == nil then
						transfer.on_hold = 1
						transfer.error = "No PayPal account"
						transfer.save
					else
						transfer.on_hold += 1
						transfer.error = "No PayPal account"
						transfer.save
					end
				end
			end
		end
	end

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while Transfer.find_by_uuid(self.uuid).present?
	end

end
