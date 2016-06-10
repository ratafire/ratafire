class Reward < ActiveRecord::Base
    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user  
    belongs_to :campaign  
    #Has many
    has_many :shippings, class_name: "Shipping", dependent: :destroy
    accepts_nested_attributes_for :shippings, :allow_destroy => true   
    has_one :shipping_anywhere, class_name: "ShippingAnywhere", dependent: :destroy
    accepts_nested_attributes_for :shipping_anywhere, limit: 1, :allow_destroy => true

    #----------------Translation----------------

    translates :title, :description

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Reward.find_by_uuid(self.uuid).present?
    end

end
