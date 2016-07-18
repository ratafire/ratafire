class Transfer < ActiveRecord::Base

    #----------------Utilities----------------
	default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create	

    #----------------Relationships----------------
    #Belongs to
	belongs_to :user

	#----------------Methods----------------

	def self.make_transfer(transfer_id)
		if @transfer = Transfer.find(transfer_id)
			if @transfer.user.stripe_account
				#Connect to stripe
				if Rails.env.production?
					Stripe.api_key = ENV['STRIPE_SECRET_KEY']
				else
					Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
				end	
				#Make transfer
				if response = Stripe::Transfer.create(
					amount: transfer.collected_amount*100,
					currency: "usd",
					destination: @transfer.user.stripe_account.stripe_id,
					description: I18n.t('ratafire')
				)
					@transfer.update(
						stripe_transfer_id: response.id,
						amount: response.amount.to_f/100,
						balance_transaction: response.balance_transaction,
						currency: response.currency,
						description: response.description,
						destination: response.destination,
						destination_payment: response.destination_payment,
						failure_code: response.failure_code,
						failure_message: response.failure_message,
						source_transaction: response.source_transaction,
						source_type: response.source_type,
						statement_descriptor: response.statement_descriptor,
						status: response.status,
					)
					if @transfer.status == "paid"
						@transfer.update(
							transfered: true,
							transfered_at: Time.now
						)
						#Send email
						Payment::TransferMailer.transfer_sent(transfer_id: @transfer.id).deliver_now
						#Send notification
						Notification.create(
							user_id: @transfer.user.id,
							trackable_id: @transfer.id,
							trackable_type: "Transfer",
							notification_type: "Transfer"
						)
					else
						@transfer.update(
							status: "Error"
						)
					end
				end
			else
				@transfer.update(
					status: "Error"
				)
			end
		end
	rescue
		if @transfer
			@transfer.update(
				status: "Error"
			)
		end
	end

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while Transfer.find_by_uuid(self.uuid).present?
	end

end