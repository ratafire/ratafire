class RewardReceiver < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
    belongs_to :campaign
    belongs_to :reward
    belongs_to :subscription
    belongs_to :shipping_address

   	#Has many
   	has_one :shippings, class_name: "Shipping", dependent: :destroy
   	accepts_nested_attributes_for :shippings, limit: 1, :allow_destroy => true   

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while RewardReceiver.find_by_uuid(self.uuid).present?
    end 

end
