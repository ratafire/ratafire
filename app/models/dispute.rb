class Dispute < ActiveRecord::Base

    #----------------Utilities----------------
	default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create	

    #----------------Relationships----------------
    #Belongs to
	belongs_to :subscriber, class_name: "User"
	belongs_to :subscribed, class_name: "User"
	belongs_to :subscription
	belongs_to :my_transaction, class_name: "Transaction"

	#Has many 
	has_many :balance_transactions

	#----------------Methods----------------

	def self.create_dispute(response)
		unless @dispute = Dispute.find_by_stripe_dispute_id(response.id)
			if @transaction = Transaction.find_by_stripe_id(response.charge)
				#Create dispute object
				if @dispute = Dispute.create(
					subscriber_id: @transaction.subscriber_id,
					subscribed_id: @transaction.subscribed_id,
					subscription_id: @transaction.subscription_id,
					transaction_id: @transaction.id,
					reward_id: @transaction.reward_id,
					stripe_dispute_id: response.id,
					stripe_balance_transaction_id: response.balance_transaction,
					stripe_amount: response.amount,
					amount: response.amount/100,
					stripe_charge_id: response.charge,
					stripe_created: response.created,
					currency: response.currency,
					is_charge_refundable: response.is_charge_refundable,
					livemode: response.livemode,
					reason: response.reason,
					stripe_status: response.status,
					due_by: response.evidence_details.due_by,
					has_evidence: response.evidence_details.has_evidence,
					past_due: response.evidence_details.past_due,
					submission_count: response.evidence_details.submission_count
				)
				@dispute_fee = ((@dispute.amount*0.029+0.3+(@dispute.amount-(@dispute.amount*0.029+0.3))*0.0005)*100).to_i+1
					#Subtract the funds from display
					@transaction.update(
						status: "Disputed",
						disputed: true,
						disputed_at: @dispute.stripe_created,
						dispute_id: @dispute.id
					)
					if @transaction.reward_id
						if @reward_receiver = RewardReceiver.find_by_reward_id_and_subscriber_id(@transaction.reward_id, @transaction.subscriber_id)
							@reward_receiver.update(
								status: "Disputed",
								disputed: true,
								disputed_at: @dispute.stripe_created,
								dispute_id: @dispute.id
							)
							@dispute.update(
								reward_receiver_id: @reward_receiver.id
							)
						end
						if @reward = Reward.find(@transaction.reward_id)
							@reward.update(
								accumulated_total: @reward.accumulated_total-@dispute.amount,
								accumulated_receive: @reward.accumulated_receive-@dispute+@dispute_fee,
								accumulated_fee: @reward.accumulated_fee-@dispute_fee,
								predicted_total: @reward.predicted_total-@dispute.amount,
								predicted_receive: @reward.predicted_receive-@dispute+@dispute_fee,
								predicted_fee: @reward.predicted_fee-@dispute_fee
							)
						end
					end
					if @dispute.subscribed_id && @dispute.subscriber_id
						if @subscription_record = SubscriptionRecord.find_by_subscriber_id_and_subscribed_id(@dispute.subscriber_id, @dispute.subscribed_id)
							@subscription_record.update(
								accumulated_total: @subscription_record.accumulated_total-@dispute.amount,
								accumulated_receive: @subscription_record.accumulated_receive-@dispute.amount+@dispute_fee,
								accumulated_fee: @subscription_record.accumulated_fee-@dispute_fee,
								counter: @subscription_record.counter-1,
								is_valid: true
							)
							if @subscription_record.accumulated_total <= 0
								@subscription_record.update(
									is_valid: false,
									accumulated_total: 0,
									accumulated_receive: 0,
									accumulated_fee: 0
								)
							end
						end
					end
					#If balance charged
					if @dispute.stripe_balance_transaction_id != nil 
						#Create balance transaction
						response.balance_transactions.each do |balance_transaction|
							unless @balance_transaction = BalanceTransaction.stripe_balance_transaction_id(balance_transaction.balance_transaction)
								if @balance_transaction = BalanceTransaction.create(
									dispute_id: @dispute.id,
									stripe_balance_transaction_id: balance_transaction.balance_transaction,
									stripe_object: balance_transaction.object,
									stripe_amount: balance_transaction.amount,
									amount: balance_transaction.amount/100,
									stripe_created: balance_transaction.created,
									currency: balance_transaction.currency,
									description: balance_transaction.description,
									stripe_fee: balance_transaction.fee,
									fee: balance_transaction.fee/100,
									fee_description: balance_transaction.fee_details.description,
									stripe_type: balance_transaction.fee_details.type,
									stripe_net: balance_transaction.net,
									net: balance_transaction.net/100,
									source: balance_transaction.source,
									stripe_status: balance_transaction.status,
								)
									#When the balance transaction is negative
									if @balance_transaction.amount < 0 && @dispute.stripe_status != "lost"
										#Debit Transfer the creator's account for the fees
										Resque.enqueue(Payment::DebitTransfer, @balance_transaction.id)
										@debit_transfer_from_subscriber = true
									end
									#When the balance transaction is positive
									if @balance_transaction.amount > 0
										Resque.enqueue(Payment::CreditTransfer, @balance_transaction.id)
										@credit_transfer_from_subscriber = true
									end
								end
							end
						end
					end
					#Email the subscribed
					Payment::DisputeMailer.create_dispute_subscribed(dispute_id: @dispute.id).deliver_now
					#Send Notification to the subscribed
					Notification.create(
						user_id: @dispute.subscribed_id,
						trackable_id: @dispute.id,
						trackable_type: "Dispute",
						notification_type: "create_dispute_subscribed"
					)
				end
			end
		end
	end

	def self.update_dispute(response)
	end

private

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while Transfer.find_by_uuid(self.uuid).present?
	end

end
