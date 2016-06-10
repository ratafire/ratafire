class Customer < ActiveRecord::Base


    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create    

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
	#Has one
	has_one :card

private

	def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Customer.find_by_uuid(self.uuid).present?
    end

end