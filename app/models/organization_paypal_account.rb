class OrganizationPaypalAccount < ActiveRecord::Base
	# attr_accessible :title, :body
	belongs_to :user
	belongs_to :organization_application
	belongs_to :organization

	def self.find_for_paypal_oauth(auth, user_id)
		paypal_created = false
		where(auth.slice(:uid)).first_or_create do |paypal|
			paypal.uid = auth.uid
			paypal.name = auth.info.name
			paypal.email = auth.info.email
			paypal.first_name = auth.info.first_name
			paypal.last_name = auth.info.last_name
			paypal.location = auth.info.location
			paypal.phone = auth.info.phone
			paypal.token = auth.credentials.token
			paypal.refresh_token = auth.credentials.refresh_token
			paypal.expires_at = auth.credentials.expires_at
			paypal.expires = auth.credentials.expires
			paypal.account_creation_date = auth.extra.account_creation_date
			paypal.account_type = auth.extra.account_type
			paypal.user_identity = auth.extra.user_id
			if auth.extra.address != nil then
				paypal.country = auth.extra.address.country
				paypal.locality = auth.extra.address.locality
				paypal.postal_code = auth.extra.address.postal_code
				paypal.region = auth.extra.address.region
				paypal.street_address = auth.extra.address.street_address
			end
			paypal.language = auth.extra.language
			paypal.locale = auth.extra.locale
			paypal.verified_account = auth.extra.verified_account
			paypal.zoneinfo = auth.extra.zoneinfo
			paypal.age_range = auth.extra.age_range
			paypal.birthday = auth.extra.birthday
			paypal.user_id = user_id
			user = User.find(user_id)
			paypal.organization_application_id = user.organization_application.id
			paypal.save
			paypal_created = true
			paypal
		end
		if paypal_created == false then
			paypal = PaypalAccount.find_by_uid(auth.uid)
			if paypal != nil then
				paypal.uid = auth.uid
				paypal.name = auth.info.name
				paypal.email = auth.info.email
				paypal.first_name = auth.info.first_name
				paypal.last_name = auth.info.last_name
				paypal.location = auth.info.location
				paypal.phone = auth.info.phone
				paypal.token = auth.credentials.token
				paypal.refresh_token = auth.credentials.refresh_token
				paypal.expires_at = auth.credentials.expires_at
				paypal.expires = auth.credentials.expires
				paypal.account_creation_date = auth.extra.account_creation_date
				paypal.account_type = auth.extra.account_type
				paypal.user_identity = auth.extra.user_id
				if auth.extra.address != nil then
					paypal.country = auth.extra.address.country
					paypal.locality = auth.extra.address.locality
					paypal.postal_code = auth.extra.address.postal_code
					paypal.region = auth.extra.address.region
					paypal.street_address = auth.extra.address.street_address
				end
				paypal.language = auth.extra.language
				paypal.locale = auth.extra.locale
				paypal.verified_account = auth.extra.verified_account
				paypal.zoneinfo = auth.extra.zoneinfo
				paypal.age_range = auth.extra.age_range
				paypal.birthday = auth.extra.birthday
				paypal.user_id = user_id
				user = User.find(user_id)		
				paypal.organization_application_id = user.organization_application.id
				paypal.save
				paypal			
			end
		end
	end
end