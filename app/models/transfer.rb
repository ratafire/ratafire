class Transfer < ActiveRecord::Base

    #----------------Utilities----------------
	default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create	

    #----------------Relationships----------------
    #Belongs to
	belongs_to :user

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while Transfer.find_by_uuid(self.uuid).present?
	end

end