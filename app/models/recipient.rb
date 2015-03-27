class Recipient < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

  def self.prefill!(recipient, user_id, account_number, ssn)
  	@recipient = Recipient.new
  	@recipient.user_id = user_id
  	@recipient.recipient_id = recipient.id
  	@recipient.object = recipient.object
  	@recipient.livemode = recipient.livemode
    @recipient.ssn = ssn
  	@recipient.klass = recipient.type
  	@recipient.description = recipient.description
  	@recipient.email = recipient.email
  	@recipient.name = recipient.name
  	@recipient.verified = recipient.verified
    @recipient.last4 = recipient.active_account.last4
  	@recipient.account_number = account_number
  	@recipient.routing_number = recipient.active_account.routing_number
  	@recipient.account_id = recipient.active_account.id
  	@recipient.bank_name = recipient.active_account.bank_name
  	@recipient.fingerprint = recipient.active_account.fingerprint
  	@recipient.account_status = recipient.active_account.status 
  	@recipient.country = recipient.active_account.country
  	@recipient.save
  end
end
