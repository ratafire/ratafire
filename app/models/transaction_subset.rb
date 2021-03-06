class TransactionSubset < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #----------------Relationships----------------
    #Belongs to
    belongs_to :my_transaction, class_name: "Transaction"
    belongs_to :subscriber, class_name: "User"

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while TransactionSubset.find_by_uuid(self.uuid).present?
    end

end