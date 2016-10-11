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
    has_one :shipping_order
   	accepts_nested_attributes_for :shippings, limit: 1, :allow_destroy => true   

    #----------------Methods----------------

    #--------Create order--------
    def self.cancel_payment(reward_receiver_id)
        @reward_receiver = RewardReceiver.find(reward_receiver_id)
        #Cancel shipping order
        if @reward_receiver.shipping_order
        end
        #Return credit to Subscription record
        #Cancel reward receiver
    end

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while RewardReceiver.find_by_uuid(self.uuid).present?
    end 

end
