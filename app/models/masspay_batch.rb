class MasspayBatch < ActiveRecord::Base
	# attr_accessible :title, :body
	has_many :transfers
	has_many :masspay_errors

	def self.create_masspay_batches
		if Transfer.where(transfered: nil, on_hold: nil, masspay_batch_id: nil).any? then
			#There is transfer this month
			#Crate masspay batch
			while Transfer.where(transfered: nil, on_hold: nil, masspay_batch_id: nil).any? do 
				masspay_batch = MasspayBatch.create
				count = 0
				while count < ENV["PAYPAL_MASSPAY_BATCH_LIMIT"].to_i do
					transfer = Transfer.where(transfered: nil,on_hold: nil, masspay_batch_id: nil).first
					if transfer == nil then
						break
					else
						transfer.update_column(:masspay_batch_id,masspay_batch.id)
						#Check the amount of the transfer to determine how many does it count in the count
						count += (transfer.collected_receive/ENV["PAYPAL_MASSPAY_TRANSACTION_LIMIT"].to_f).to_i+1
						if count > ENV["PAYPAL_MASSPAY_BATCH_LIMIT"].to_i then
							transfer.update_column(:masspay_batch_id,nil)
						end
					end
				end
			end
		end
	end

	def self.perform_masspay
		still_short_amount = 0
		@masspay_log = MasspayLog.new
		MasspayBatch.where(transfered: nil, :on_hold => 0).all.each do |masspay_batch|
			begin
				#Make an array of the masspay
				batched_list = Array.new()
				batched_amount = 0
				if masspay_batch.transfers.any? then
					masspay_batch.transfers.all.each do |transfer|
						if transfer.collected_receive > ENV["PAYPAL_MASSPAY_TRANSACTION_LIMIT"].to_f then
							#Transfer amount is larger than 10000 so we need to batch it several times
							batch_remain = transfer.collected_receive
							while batch_remain > 0 do
								if (batch_remain/ENV["PAYPAL_MASSPAY_TRANSACTION_LIMIT"].to_f).to_i > 0 then
									batched_list << {
										:ReceiverEmail => transfer.user.paypal_account.email,
										:Amount => {
											:currencyID => "USD",
											:value => batch_remain.to_s
										}
									}
									batch_remain -= batch_remain
								else
									batched_list << {
										:ReceiverEmail => transfer.user.paypal_account.email,
										:Amount => {
											:currencyID => "USD",
											:value => ENV["PAYPAL_MASSPAY_TRANSACTION_LIMIT"]
										}
									}
									batch_remain -= ENV["PAYPAL_MASSPAY_TRANSACTION_LIMIT"].to_f
								end
							end
						else
							batched_list << {
								:ReceiverEmail => transfer.user.paypal_account.email,
								:Amount => {
									:currencyID => "USD",
									:value => transfer.collected_receive.to_s
								}
							}
						end
						transfer.update_column(:queued, true)
						batched_amount += transfer.collected_receive
					end
				end

				if batched_list.size <= ENV["PAYPAL_MASSPAY_BATCH_LIMIT"].to_i && batched_list.size > 0 then
					@api = PayPal::SDK::Merchant::API.new
					#Get Balance to check if the balance is enough
					@get_balance = @api.build_get_balance({:ReturnAllCurrencies => "0" }) #Returns only the primary currency holdings
					@get_balance_response = @api.get_balance(@get_balance)
					if batched_amount < @get_balance_response.Balance.value.to_f then
						#Build request object
						@mass_pay = @api.build_mass_pay({
							:ReceiverType => "EmailAddress",
							:MassPayItem => batched_list
							})
						# Make API call & get response
						@mass_pay_response = @api.mass_pay(@mass_pay)
						# Access Response
						if @mass_pay_response.success?
							#Log the result for masspay batches
							masspay_batch.transfered = true
							masspay_batch.transfered_at = Time.now
							masspay_batch.ack = @mass_pay_response.Ack
							masspay_batch.amount = batched_amount
							masspay_batch.correlation_id = @mass_pay_response.CorrelationID
							masspay_batch.save
							#Log the result for transfers
							masspay_batch.transfers.each do |transfer|
								transfer.transfered = true
								transfer.transfered_at = Time.now
								transfer.save
								#Tell the subscribed the transfer is initiated
								SubscriptionMailer.transfered(transfer.id).deliver		
								#Record it to billing_artists
								billing_artist = BillingArtist.find_by_user_id(transfer.user_id)
								billing_artist.accumulated_receive += transfer.collected_receive
								billing_artist.accumulated_payment_fee += transfer.collected_fee
								billing_artist.accumulated_total += transfer.collected_amount
								billing_artist.prev_billing_date = billing_artist.this_billing_date
								billing_artist.this_billing_date = billing_artist.next_billing_date
								billing_artist.next_billing_date = Time.now.beginning_of_month.next_month + 27.day	
								billing_artist.this_amount = billing_artist.next_amount
								billing_artist.next_amount = 0
								billing_artist.save			
							end
							#Add to MasspayLog
							@masspay_log.count += 1
							@masspay_log.amount += batched_amount
							@masspay_log.correlation_id = @mass_pay_response.CorrelationID
							@masspay_log.save
						else
							#log error message
							@mass_pay_response.Errors.each do |error|
								masspay_error = MasspayError.create
								masspay_error.masspay_batch_id = masspay_batch.id
								masspay_error.error_code = error.ErrorCode
								masspay_error.error_long_message = error.LongMessage
								masspay_error.error_short_message = error.ShortMessage
								masspay_error.save
							end
							#Send admin an email
						 	SubscriptionMailer.transfer_admin_emails(4, :masspay_batch_id => masspay_batch.id).deliver	
							masspay_batch.on_hold += 1
							masspay_batch.save
						end
					else
						#Add the amount to still short amount
						still_short_amount += batched_amount
						#Mark the batch as on_hold
						masspay_batch.on_hold += 1
						masspay_batch.save
						masspay_error = MasspayError.create
						masspay_error.masspay_batch_id = masspay_batch.id
						masspay_error.error_short_message = "There is no enough money in the PayPal balance."
						#Short
						@short = true
					end
				else
					#Send admin an email
					SubscriptionMailer.transfer_admin_emails(4, :masspay_batch_id => masspay_batch.id).deliver	
					masspay_batch.on_hold += 1
					masspay_batch.save				
				end
			rescue
				SubscriptionMailer.transfer_admin_emails(7, :masspay_batch_id => masspay_batch.id).deliver	
				masspay_batch.on_hold += 1
				masspay_batch.save							
			end
		end # end MasspayBatch.where(transfered: nil, :on_hold => 0).all.each do |masspay_batch|
		#Tell the admin this month's masspay has performed
		SubscriptionMailer.transfer_admin_emails(6, :transfered_amount => @masspay_log.amount).deliver	
		#Tell the admin there is a batch too large, if so
		if @short == true then
			@get_balance = @api.build_get_balance({:ReturnAllCurrencies => "0" }) #Returns only the primary currency holdings
			@get_balance_response = @api.get_balance(@get_balance)
			still_short_amount = still_short_amount - @get_balance_response.Balance.value.to_f
			SubscriptionMailer.transfer_admin_emails(1, :still_short_amount => still_short_amount.to_s).deliver	
		end
	end

end
