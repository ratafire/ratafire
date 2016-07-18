class OrderSubset < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Belongs to
    belongs_to :order
    belongs_to :user, class_name: "User"

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while OrderSubset.find_by_uuid(self.uuid).present?
    end

end
