class ShippingAddress < ActiveRecord::Base

    #----------------Utilities----------------

    #Default scope
	default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create	

	#--------Encryption--------
	attr_encrypted :postal_code, key: ENV['ADDRESS_ZIP_KEY'] 

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
    belongs_to :subscription
    belongs_to :reward

    #Has many
    has_many :reward_receivers,
        -> { where(reward_receivers:{:deleted => nil })}

    #----------------Validation----------------
    #Country
    validates :country, uniqueness: { scope: :user_id, message: :one_shipping_address_per_country }

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while ShippingAddress.find_by_uuid(self.uuid).present?
    end

end
