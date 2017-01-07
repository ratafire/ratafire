class ShippingOrder < ActiveRecord::Base

    #----------------Utilities----------------
    
    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Belongs to
    belongs_to :reward
    belongs_to :reward_receiver
    belongs_to :user

    #----------------Methods----------------

    def self.transaction_failed(shipping_order_id)
    end

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(18)
        end while ShippingOrder.find_by_uuid(self.uuid).present?
    end
end
