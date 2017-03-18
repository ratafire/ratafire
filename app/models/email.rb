class Email < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

private

    def generate_uuid!
        begin
            self.uid = SecureRandom.hex(16)
        end while Email.find_by_uid(self.uid).present?
    end

end
