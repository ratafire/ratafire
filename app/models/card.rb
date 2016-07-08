class Card < ActiveRecord::Base

    #----------------Utilities----------------

	#--------Encryption--------
	attr_encrypted :card_number, key: ENV['CARD_NUMBER_KEY']
    attr_encrypted :exp_month, key: ENV['EXP_MONTH_KEY']
    attr_encrypted :exp_year, key: ENV['EXP_YEAR_KEY']
    attr_encrypted :cvc, key: ENV['CVC_KEY']    
    attr_encrypted :address_zip, key: ENV['ADDRESS_ZIP_KEY']    

    #Generate uuid
    before_validation :generate_uuid!, :on => :create    

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
	belongs_to :customer
    belongs_to :subscription

private

	def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Card.find_by_uuid(self.uuid).present?
    end

end