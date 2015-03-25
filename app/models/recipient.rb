class Recipient < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

  def self.prefill!(recipient, user_id)
  	@recipient = Recipient.new
  	@recipient.user_id = user_id
  	@recipient.recipient_id = recipient.id
  	@recipient.object = recipient.object
  	@recipient.livemode = recipient.livemode
  	@recipient.klass = recipient.type
  	@recipient.description = recipient.description
  	@recipient.email = recipient.email
  	@recipient.name = recipient.name
  	@recipient.verified = recipient.verified
  	@recipient.account_number = recipient.active_account.last4
  	@recipient.routing_number = recipient.active_account.routing_number
  	@recipient.account_id = recipient.active_account.id
  	@recipient.bank_name = recipient.active_account.bank_name
  	@recipient.fingerprint = recipient.active_account.fingerprint
  	@recipient.account_status = recipient.active_account.status 
  	@recipient.country = recipient.active_account.country
    @recipient.tax_id = params[:ssn]
  	@recipient.save
  end
end
