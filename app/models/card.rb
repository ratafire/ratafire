class Card < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create    

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
	belongs_to :customer

private

	def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Card.find_by_uuid(self.uuid).present?
    end

end