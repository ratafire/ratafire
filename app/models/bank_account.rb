class BankAccount < ActiveRecord::Base
	#----------------Utilities----------------

	#--------Encryption--------
	attr_encrypted :account_number, key: ENV['ACCOUNT_NUMBER_KEY']
    attr_encrypted :routing_number, key: ENV['ROUTING_NUMBER_KEY']
    attr_encrypted :postal_code, key: ENV['POSTAL_CODE_KEY']

    #Generate uuid
    before_validation :generate_uuid!, :on => :create	

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while IdentityVerification.find_by_uuid(self.uuid).present?
    end

end
