class Admin::Keystone

	#Put due campaign on queue
	@queue = :admin

	def self.perform
		BankAccount.where.not(encrypted_account_number: nil).each do |bank_account|
			ibifrost = Ibifrost.create(
				item_id: bank_account.id,
				user_id: bank_account.user_id,
				item_type: '1',
				bifrost: bank_account.encrypted_account_number
			)
			bank_account.update(
				encrypted_account_number: nil
			)
		end
		IdentityVerification.where.not(encrypted_ssn: nil).each do |identity_verification|
			ibifrost = Ibifrost.create(
				item_id: identity_verification.id,
				user_id: identity_verification.user_id,
				item_type: '2',
				bifrost: identity_verification.encrypted_ssn
			)
			identity_verification.update(
				encrypted_ssn: nil
			)
		end
		Card.where.not(encrypted_card_number: nil).each do |card|
			ibifrost = Ibifrost.create(
				item_id: card.id,
				user_id: card.user_id,
				item_type: '3',
				bifrost: card.encrypted_card_number
			)
			card.update(
				encrypted_card_number: nil
			)
		end
	end

end