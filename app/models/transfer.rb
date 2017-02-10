class Transfer < ActiveRecord::Base

    #----------------Utilities----------------
	default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create	

    #----------------Relationships----------------
    #Belongs to
	belongs_to :user

	#----------------Methods----------------

	def self.make_transfer(transfer_id, stripe_account_id)
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
					{
						amount: @transfer.amount*100,
						currency: "usd",
						destination: "default_for_currency",
						description: I18n.t('ratafire')
					},
					{ 
						stripe_account: stripe_account_id
					}
				)
					@transfer.update(
						stripe_transfer_id: response.id,
						amount: response.amount.to_f/100,
						balance_transaction: response.balance_transaction,
						currency: response.currency,
						description: response.description,
						destination: response.destination,

						failure_code: response.failure_code,
						failure_message: response.failure_message,
						source_transaction: response.source_transaction,
						source_type: response.source_type,
						statement_descriptor: response.statement_descriptor,
						status: response.status,
						transfered_at: Time.now
					)
					if @transfer.status == "paid"
						@transfer.update(
							transfered: true,
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
						#When the transfer is not paid
					end
				end
			else
				@transfer.update(
					status: "canceled"
				)
			end
		end
	rescue
		@transfer.update(
			status: "canceled"
		)
	end

	def self.create_transfer(response)
		unless @transfer = Transfer.find_by_stripe_transfer_id(response.id)
			if @stripe_account = StripeAccount.find_by_stripe_id(response.destination)
				@transfer = Transfer.create(
					user_id: @stripe_account.user_id,
					amount: response.amount/100,
					status: response.status,
					stripe_transfer_id: response.id
				)
				if @transfer.status == "paid"
					@transfer.update(
						transfered: true,
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
					if @transfer.status == "failed"
						@transfer.update(
							transfered: false,
						)
					end
				end
			end
		end
	end

	def self.update_transfer(response)
		if @transfer = Transfer.find_by_stripe_transfer_id(response.id)
			@transfer.update(
				failure_code: response.failure_code,
				failure_message: response.failure_message,
				statement_descriptor: response.statement_descriptor,
				status: response.status,
				stripe_transfer_id: response.id
			)
			if @transfer.status == "paid"
				@transfer.update(
					transfered: true,
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
				if @transfer.status == "failed"
					@transfer.update(
						transfered: false,
					)
				end
			end
		end
	end

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while Transfer.find_by_uuid(self.uuid).present?
	end

end