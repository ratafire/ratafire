class StripeAccount < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create
    
    #----------------Relationships----------------
    #Belongs to
    belongs_to :user

    #----------------Stripe----------------

    def self.stripe_account_create(stripe_account, user_id)
    	self.create(
            stripe_id: stripe_account.id,
    		user_id: user_id,
    		object: stripe_account.object,
    		charges_enabled: stripe_account.charges_enabled,
    		country: stripe_account.country,
    		debit_negative_balances: stripe_account.debit_negative_balances,
    		avs_failure: stripe_account.decline_charge_on.avs_failure,
    		cvc_failure: stripe_account.decline_charge_on.cvc_failure,
    		default_currency: stripe_account.default_currency,
    		details_submitted: stripe_account.details_submitted,
    		display_name: stripe_account.display_name,
    		email: stripe_account.email,
            state: stripe_account.legal_entity.address.state,
    		city: stripe_account.legal_entity.address.city,
    		line1: stripe_account.legal_entity.address.line1,
    		line2: stripe_account.legal_entity.address.line2,
    		postal_code: stripe_account.legal_entity.address.postal_code,
    		tos_acceptance_date: stripe_account.tos_acceptance.date,
    		tos_acceptance_ip: stripe_account.tos_acceptance.ip,
    		first_name: stripe_account.legal_entity.first_name,
    		last_name: stripe_account.legal_entity.last_name,
            verification_details: stripe_account.legal_entity.verification.details,
            verification_details_code: stripe_account.legal_entity.verification.details_code,
            verification_document: stripe_account.legal_entity.verification.document,
            verification_status: stripe_account.legal_entity.verification.status,
            transfer_schedule_interval: stripe_account.transfer_schedule.interval
    	)
    end


    def self.stripe_account_update(stripe_account, user_id)
        user_stripe_account = StripeAccount.find_by_user_id(user_id)
    	user_stripe_account.update(
    		object: stripe_account.object,
    		charges_enabled: stripe_account.charges_enabled,
    		debit_negative_balances: stripe_account.debit_negative_balances,
    		avs_failure: stripe_account.decline_charge_on.avs_failure,
    		cvc_failure: stripe_account.decline_charge_on.cvc_failure,
    		default_currency: stripe_account.default_currency,
    		details_submitted: stripe_account.details_submitted,
    		display_name: stripe_account.display_name,
    		email: stripe_account.email,
            state: stripe_account.legal_entity.address.state,
    		city: stripe_account.legal_entity.address.city,
    		line1: stripe_account.legal_entity.address.line1,
    		line2: stripe_account.legal_entity.address.line2,
    		postal_code: stripe_account.legal_entity.address.postal_code,
    		tos_acceptance_date: stripe_account.tos_acceptance.date,
    		tos_acceptance_ip: stripe_account.tos_acceptance.ip,
    		first_name: stripe_account.legal_entity.first_name,
    		last_name: stripe_account.legal_entity.last_name,
            verification_details: stripe_account.legal_entity.verification.details,
            verification_details_code: stripe_account.legal_entity.verification.details_code,
            verification_document: stripe_account.legal_entity.verification.document,
            verification_status: stripe_account.legal_entity.verification.status,
            transfer_schedule_interval: stripe_account.transfer_schedule.interval
    	)
        return user_stripe_account
    end    

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while StripeAccount.find_by_uuid(self.uuid).present?
    end

end
