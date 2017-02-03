class Shipping < ActiveRecord::Base
    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Belongs to
    belongs_to :reward  
    belongs_to :campaign

    #Validations
    validates :country, presence: true

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Shipping.find_by_uuid(self.uuid).present?
    end

end
