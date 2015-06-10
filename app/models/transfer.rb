class Transfer < ActiveRecord::Base
	# attr_accessible :title, :body
	belongs_to :user
	default_scope order: 'transfers.created_at DESC'
	before_validation :generate_uuid!, :on => :create
	belongs_to :masspay_batch

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while Transfer.find_by_uuid(self.uuid).present?
	end

end
