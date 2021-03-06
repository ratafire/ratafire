class HistoricalQuote < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user

    #----------------Translation----------------
	translates :quote, :author, :source, :chapter, :original_language, :category

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while HistoricalQuote.find_by_uuid(self.uuid).present?
    end

end
