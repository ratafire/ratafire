class Link < ActiveRecord::Base

	#----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #--------Friendlyid--------
    extend FriendlyId
    friendly_id :uuid    

    #----------------Relationships----------------
    #Belongs to
    belongs_to :majorpost, class_name: "Majorpost"
    belongs_to :user

    #----------------Validation----------------
    validates :majorpost_uuid, :uniqueness => true

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Link.find_by_uuid(self.uuid).present?
    end

end
