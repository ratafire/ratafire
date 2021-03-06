class ShippingAnywhere < ActiveRecord::Base
    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Belongs to
    belongs_to :reward  
    belongs_to :campaign

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while ShippingAnywhere.find_by_uuid(self.uuid).present?
    end	
end
