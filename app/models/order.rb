class Order < ActiveRecord::Base
	# attr_accessible :title, :body
	def self.transact_order(order_id, user_id)
		@order = Order.find(order_id)
		@subscriber = User.find(user_id)
		if @subscriber.default_billing_method == "PayPal" then
			#PayPal
			begin
				if Rails.env.development? then
					@request = Paypal::Express::Request.new(
		  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
		  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
		  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
					)	
				else
					@request = Paypal::Express::Request.new(
		  				:username   => ENV["PAYPAL_USERNAME"],
		  				:password   => ENV["PAYPAL_PASSWORD"],
		  				:signature  => ENV["PAYPAL_SIGNATURE"]
					)				
				end			
				response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscriber.order.amount.to_i
			rescue
				#Fail to process payment by PayPal
				#Send email
				SubscriptionMailer.fail_to_process_payment(@order.id,"PayPal").deliver	
			end
			if response.ack == "Success" then
				#Record transaction
				transaction = Transaction.paypal!(
					response,
					:order_id => @order.id,
					:subscriber_id => @subscriber.id,
					:transaction_method => "PayPal"
				)
				#Record Transfer
				@fee = transaction.fee / @order.count if @order.count != 0
				@subscriber.reverse_subscriptions.each do |subscription| 
					subscribed = User.find(subscription.subscribed_id)
					if subscribed != nil && subscribed.transfer != nil then
						#If the subscribed has order this month
						if subscribed.transfer.ordered_amount != 0 then
							#Transfer
							transfer = subscribed.transfer
							transfer.collected_receive += ( subscription.amount - @fee)
							transfer.collected_amount += subscription.amount
							transfer.collected_fee += @fee
							transfer.save
							#Subscription Record
							subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
							if subscription_record == nil then
								subscription_record = SubscriptionRecord.new
								subscription_record.subscriber_id = subscription.subscriber_id
								subscription_record.subscribed_id = subscription.subscribed_id
								subscription_record.supporter_switch = subscription.supporter_switch
								subscription_record.accumulated_total = subscription.amount
								subscription_record.accumulated_receive = ( subscription.amount - @fee)
								subscription_record.accumulated_fee = @fee
								subscription_record.counter = subscription_record.counter+1
								subscription_record.save				
							else
								subscription_record.accumulated_total += subscription.amount
								subscription_record.accumulated_receive += ( subscription.amount - @fee)
								subscription_record.accumulated_fee += @fee									
								subscription_record.supporter_switch = subscription.supporter_switch
								subscription_record.counter += 1
								subscription_record.save
							end
							#Subscription
							subscription.accumulated_total += subscription.amount
							subscription.accumulated_receive += ( subscription.amount - @fee )
							subscription.accumulated_fee += @fee
							subscription.counter += 1
							subscription.subscription_record_id = subscription_record.id
							subscription.save
						end
					end
				end
				#Record Order
				@order.transacted = true
				@order.transacted_at = Time.now
				@order.save
				#Billing Subscription
				@billing_subscription = @subscriber.billing_subscription
				@billing_subscription.accumulated_total += transaction.total
				@billing_subscription.accumulated_payment_fee += transaction.fee
				@billing_subscription.accumulated_receive += transaction.receive
				#Send email to subscribed
				SubscriptionMailer.successful_order(@order.id).deliver
			else
				if @subscriber.cards.first != nil then
					#Card
					response = Stripe::Charge.create(
						:amount => @order.amount.to_i*100,
						:currency => "usd",
						:customer => @subscriber.customer.customer_id,
						:description => "Ratafire subscription fee of the month."
					)		
					if response.captured == true then
						#Record transaction
						transaction = Transaction.prefill!(
							response,
							:order_id => @order.id,
							:subscriber_id => @subscriber.id,
							:fee => @order.amount.to_f*0.029+0.30,
							:transaction_method => "Stripe"
						)
						#Record Transfer
						@fee = transaction.fee / @order.count if @order.count != 0
						@subscriber.reverse_subscriptions.each do |subscription| 
							subscribed = User.find(subscription.subscribed_id)
							if subscribed != nil && subscribed.transfer != nil then
								#If the subscribed has order this month
								if subscribed.transfer.ordered_amount != 0 then
									#Transfer
									transfer = subscribed.transfer
									transfer.collected_receive += ( subscription.amount - @fee)
									transfer.collected_amount += subscription.amount
									transfer.collected_fee += @fee
									transfer.save
									#Subscription Record
									subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
									if subscription_record == nil then
										subscription_record = SubscriptionRecord.new
										subscription_record.subscriber_id = subscription.subscriber_id
										subscription_record.subscribed_id = subscription.subscribed_id
										subscription_record.supporter_switch = subscription.supporter_switch
										subscription_record.accumulated_total = subscription.amount
										subscription_record.accumulated_receive = ( subscription.amount - @fee)
										subscription_record.accumulated_fee = @fee
										subscription_record.counter = subscription_record.counter+1
										subscription_record.save				
									else
										subscription_record.accumulated_total += subscription.amount
										subscription_record.accumulated_receive += ( subscription.amount - @fee)
										subscription_record.accumulated_fee += @fee									
										subscription_record.supporter_switch = subscription.supporter_switch
										subscription_record.counter += 1
										subscription_record.save
									end
									#Subscription
									subscription.accumulated_total += subscription.amount
									subscription.accumulated_receive += ( subscription.amount - @fee )
									subscription.accumulated_fee += @fee
									subscription.counter += 1
									subscription.subscription_record_id = subscription_record.id
									subscription.save
								end
							end
						end
						#Record Order
						@order.transacted = true
						@order.transacted_at = Time.now
						@order.save
						#Billing Subscription
						@billing_subscription = @subscriber.billing_subscription
						@billing_subscription.accumulated_total += transaction.total
						@billing_subscription.accumulated_payment_fee += transaction.fee
						@billing_subscription.accumulated_receive += transaction.receive
						#Send email to subscribed
						SubscriptionMailer.successful_order(@order.id).deliver						
					else
						#Fail to process payment by PayPal and Card
						#Send email
						SubscriptionMailer.fail_to_process_payment(@order.id,"both").deliver
					end	
				else
					#Fail to process payment by PayPal
					#Send email	
					SubscriptionMailer.fail_to_process_payment(@order.id,"PayPal").deliver						
				end				
			end
		else
			if @subscriber.default_billing_method == "Card" then
				#Card
				begin
					response = Stripe::Charge.create(
						:amount => @order.amount.to_i*100,
						:currency => "usd",
						:customer => @subscriber.customer.customer_id,
						:description => "Ratafire subscription fee of the month."
					)
				rescue
					#Fail to process payment by Card
					#Send email
					SubscriptionMailer.fail_to_process_payment(@order.id,"Card").deliver	
				end		
				if response.captured == true then
					#Record transaction
					transaction = Transaction.prefill!(
						response,
						:order_id => @order.id,
						:subscriber_id => @subscriber.id,
						:fee => @order.amount.to_f*0.029+0.30,
						:transaction_method => "Stripe"
					)
					#Record Transfer
					@fee = transaction.fee / @order.count if @order.count != 0
					@subscriber.reverse_subscriptions.each do |subscription| 
						subscribed = User.find(subscription.subscribed_id)
						if subscribed != nil && subscribed.transfer != nil then
							#If the subscribed has order this month
							if subscribed.transfer.ordered_amount != 0 then
								#Transfer
								transfer = subscribed.transfer
								transfer.collected_receive += ( subscription.amount - @fee)
								transfer.collected_amount += subscription.amount
								transfer.collected_fee += @fee
								transfer.save
								#Subscription Record
								subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
								if subscription_record == nil then
									subscription_record = SubscriptionRecord.new
									subscription_record.subscriber_id = subscription.subscriber_id
									subscription_record.subscribed_id = subscription.subscribed_id
									subscription_record.supporter_switch = subscription.supporter_switch
									subscription_record.accumulated_total = subscription.amount
									subscription_record.accumulated_receive = ( subscription.amount - @fee)
									subscription_record.accumulated_fee = @fee
									subscription_record.counter = subscription_record.counter+1
									subscription_record.save				
								else
									subscription_record.accumulated_total += subscription.amount
									subscription_record.accumulated_receive += ( subscription.amount - @fee)
									subscription_record.accumulated_fee += @fee									
									subscription_record.supporter_switch = subscription.supporter_switch
									subscription_record.counter += 1
									subscription_record.save
								end
								#Subscription
								subscription.accumulated_total += subscription.amount
								subscription.accumulated_receive += ( subscription.amount - @fee )
								subscription.accumulated_fee += @fee
								subscription.counter += 1
								subscription.subscription_record_id = subscription_record.id
								subscription.save
							end
						end
					end
					#Record Order
					@order.transacted = true
					@order.transacted_at = Time.now
					@order.save
					#Billing Subscription
					@billing_subscription = @subscriber.billing_subscription
					@billing_subscription.accumulated_total += transaction.total
					@billing_subscription.accumulated_payment_fee += transaction.fee
					@billing_subscription.accumulated_receive += transaction.receive
					#Send email to subscribed
					SubscriptionMailer.successful_order(@order.id).deliver
				else
					if @subscriber.billing_agreement != nil then
						#PayPal
						if Rails.env.development? then
							@request = Paypal::Express::Request.new(
				  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
				  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
				  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
							)	
						else
							@request = Paypal::Express::Request.new(
				  				:username   => ENV["PAYPAL_USERNAME"],
				  				:password   => ENV["PAYPAL_PASSWORD"],
				  				:signature  => ENV["PAYPAL_SIGNATURE"]
							)				
						end			
						response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscriber.order.amount.to_i
						if response.ack == "Success" then
							#Record transaction
							transaction = Transaction.paypal!(
								response,
								:order_id => @order.id,
								:subscriber_id => @subscriber.id,
								:transaction_method => "PayPal"
							)
							#Record Transfer
							@fee = transaction.fee / @order.count if @order.count != 0
							@subscriber.reverse_subscriptions.each do |subscription| 
								subscribed = User.find(subscription.subscribed_id)
								if subscribed != nil && subscribed.transfer != nil then
									#If the subscribed has order this month
									if subscribed.transfer.ordered_amount != 0 then
										#Transfer
										transfer = subscribed.transfer
										transfer.collected_receive += ( subscription.amount - @fee)
										transfer.collected_amount += subscription.amount
										transfer.collected_fee += @fee
										transfer.save
										#Subscription Record
										subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
										if subscription_record == nil then
											subscription_record = SubscriptionRecord.new
											subscription_record.subscriber_id = subscription.subscriber_id
											subscription_record.subscribed_id = subscription.subscribed_id
											subscription_record.supporter_switch = subscription.supporter_switch
											subscription_record.accumulated_total = subscription.amount
											subscription_record.accumulated_receive = ( subscription.amount - @fee)
											subscription_record.accumulated_fee = @fee
											subscription_record.counter = subscription_record.counter+1
											subscription_record.save				
										else
											subscription_record.accumulated_total += subscription.amount
											subscription_record.accumulated_receive += ( subscription.amount - @fee)
											subscription_record.accumulated_fee += @fee									
											subscription_record.supporter_switch = subscription.supporter_switch
											subscription_record.counter += 1
											subscription_record.save
										end
										#Subscription
										subscription.accumulated_total += subscription.amount
										subscription.accumulated_receive += ( subscription.amount - @fee )
										subscription.accumulated_fee += @fee
										subscription.counter += 1
										subscription.subscription_record_id = subscription_record.id
										subscription.save
									end
								end
							end
							#Record Order
							@order.transacted = true
							@order.transacted_at = Time.now
							@order.save
							#Billing Subscription
							@billing_subscription = @subscriber.billing_subscription
							@billing_subscription.accumulated_total += transaction.total
							@billing_subscription.accumulated_payment_fee += transaction.fee
							@billing_subscription.accumulated_receive += transaction.receive
							#Send email to subscribed
							SubscriptionMailer.successful_order(@order.id).deliver
						else
							#Fail to process payment by PayPal and Card
							#Send email
							SubscriptionMailer.fail_to_process_payment(@order.id,"both").deliver
						end
					else
						#Fail to process payment by Card
						#Send email		
						SubscriptionMailer.fail_to_process_payment(@order.id,"Card").deliver
					end
				end						
			else
				if @subscriber.billing_agreement != nil then
					begin
						#PayPal
						if Rails.env.development? then
							@request = Paypal::Express::Request.new(
				  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
				  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
				  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
							)	
						else
							@request = Paypal::Express::Request.new(
				  				:username   => ENV["PAYPAL_USERNAME"],
				  				:password   => ENV["PAYPAL_PASSWORD"],
				  				:signature  => ENV["PAYPAL_SIGNATURE"]
							)				
						end			
						response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscriber.order.amount.to_i
					rescue
						#Fail to process payment by PayPal
						#Send email
						SubscriptionMailer.fail_to_process_payment(@order.id,"PayPal").deliver									
					end
					if response.ack == "Success" then
						#Record transaction
						transaction = Transaction.paypal!(
							response,
							:order_id => @order.id,
							:subscriber_id => @subscriber.id,
							:transaction_method => "PayPal"
						)
						#Record Transfer
						@fee = transaction.fee / @order.count if @order.count != 0
						@subscriber.reverse_subscriptions.each do |subscription| 
							subscribed = User.find(subscription.subscribed_id)
							if subscribed != nil && subscribed.transfer != nil then
								#If the subscribed has order this month
								if subscribed.transfer.ordered_amount != 0 then
									#Transfer
									transfer = subscribed.transfer
									transfer.collected_receive += ( subscription.amount - @fee)
									transfer.collected_amount += subscription.amount
									transfer.collected_fee += @fee
									transfer.save
									#Subscription Record
									subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
									if subscription_record == nil then
										subscription_record = SubscriptionRecord.new
										subscription_record.subscriber_id = subscription.subscriber_id
										subscription_record.subscribed_id = subscription.subscribed_id
										subscription_record.supporter_switch = subscription.supporter_switch
										subscription_record.accumulated_total = subscription.amount
										subscription_record.accumulated_receive = ( subscription.amount - @fee)
										subscription_record.accumulated_fee = @fee
										subscription_record.counter = subscription_record.counter+1
										subscription_record.save				
									else
										subscription_record.accumulated_total += subscription.amount
										subscription_record.accumulated_receive += ( subscription.amount - @fee)
										subscription_record.accumulated_fee += @fee									
										subscription_record.supporter_switch = subscription.supporter_switch
										subscription_record.counter += 1
										subscription_record.save
									end
									#Subscription
									subscription.accumulated_total += subscription.amount
									subscription.accumulated_receive += ( subscription.amount - @fee )
									subscription.accumulated_fee += @fee
									subscription.counter += 1
									subscription.subscription_record_id = subscription_record.id
									subscription.save
								end
							end
						end
						#Record Order
						@order.transacted = true
						@order.transacted_at = Time.now
						@order.save
						#Billing Subscription
						@billing_subscription = @subscriber.billing_subscription
						@billing_subscription.accumulated_total += transaction.total
						@billing_subscription.accumulated_payment_fee += transaction.fee
						@billing_subscription.accumulated_receive += transaction.receive
						#Send email to subscribed
						SubscriptionMailer.successful_order(@order.id).deliver
					else
						if @subscriber.cards.first != nil then
							#Card
							begin
								response = Stripe::Charge.create(
									:amount => @order.amount.to_i*100,
									:currency => "usd",
									:customer => @subscriber.customer.customer_id,
									:description => "Ratafire subscription fee of the month."
								)		
							rescue
								#Fail to process payment by Card
								#Send email
								SubscriptionMailer.fail_to_process_payment(@order.id,"Card").deliver	
							end
							if response.captured == true then
								#Record transaction
								transaction = Transaction.prefill!(
									response,
									:order_id => @order.id,
									:subscriber_id => @subscriber.id,
									:fee => @order.amount.to_f*0.029+0.30,
									:transaction_method => "Stripe"
								)
								#Record Transfer
								@fee = transaction.fee / @order.count if @order.count != 0
								@subscriber.reverse_subscriptions.each do |subscription| 
									subscribed = User.find(subscription.subscribed_id)
									if subscribed != nil && subscribed.transfer != nil then
										#If the subscribed has order this month
										if subscribed.transfer.ordered_amount != 0 then
											#Transfer
											transfer = subscribed.transfer
											transfer.collected_receive += ( subscription.amount - @fee)
											transfer.collected_amount += subscription.amount
											transfer.collected_fee += @fee
											transfer.save
											#Subscription Record
											subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
											if subscription_record == nil then
												subscription_record = SubscriptionRecord.new
												subscription_record.subscriber_id = subscription.subscriber_id
												subscription_record.subscribed_id = subscription.subscribed_id
												subscription_record.supporter_switch = subscription.supporter_switch
												subscription_record.accumulated_total = subscription.amount
												subscription_record.accumulated_receive = ( subscription.amount - @fee)
												subscription_record.accumulated_fee = @fee
												subscription_record.counter = subscription_record.counter+1
												subscription_record.save				
											else
												subscription_record.accumulated_total += subscription.amount
												subscription_record.accumulated_receive += ( subscription.amount - @fee)
												subscription_record.accumulated_fee += @fee									
												subscription_record.supporter_switch = subscription.supporter_switch
												subscription_record.counter += 1
												subscription_record.save
											end
											#Subscription
											subscription.accumulated_total += subscription.amount
											subscription.accumulated_receive += ( subscription.amount - @fee )
											subscription.accumulated_fee += @fee
											subscription.counter += 1
											subscription.subscription_record_id = subscription_record.id
											subscription.save
										end
									end
								end
								#Record Order
								@order.transacted = true
								@order.transacted_at = Time.now
								@order.save
								#Billing Subscription
								@billing_subscription = @subscriber.billing_subscription
								@billing_subscription.accumulated_total += transaction.total
								@billing_subscription.accumulated_payment_fee += transaction.fee
								@billing_subscription.accumulated_receive += transaction.receive
								#Send email to subscribed
								SubscriptionMailer.successful_order(@order.id).deliver				
							else
								#Fail to process payment by PayPal and Card
								#Send email
								SubscriptionMailer.fail_to_process_payment(@order.id,"both").deliver
							end	
						else
							#Fail to process payment by PayPal
							#Send email	
							SubscriptionMailer.fail_to_process_payment(@order.id,"PayPal").deliver						
						end				
					end
				else
					if @subscriber.cards.first != nil then
						#Card
						begin
							response = Stripe::Charge.create(
								:amount => @order.amount.to_i*100,
								:currency => "usd",
								:customer => @subscriber.customer.customer_id,
								:description => "Ratafire subscription fee of the month."
							)	
						rescue
							#Fail to process payment by Card
							#Send email
							SubscriptionMailer.fail_to_process_payment(@order.id,"Card").deliver
						end	
						if response.captured == true then
							#Record transaction
							transaction = Transaction.prefill!(
								response,
								:order_id => @order.id,
								:subscriber_id => @subscriber.id,
								:fee => @order.amount.to_f*0.029+0.30,
								:transaction_method => "Stripe"
							)
							#Record Transfer
							@fee = transaction.fee / @order.count if @order.count != 0
							@subscriber.reverse_subscriptions.each do |subscription| 
								subscribed = User.find(subscription.subscribed_id)
								if subscribed != nil && subscribed.transfer != nil then
									#If the subscribed has order this month
									if subscribed.transfer.ordered_amount != 0 then
										#Transfer
										transfer = subscribed.transfer
										transfer.collected_receive += ( subscription.amount - @fee)
										transfer.collected_amount += subscription.amount
										transfer.collected_fee += @fee
										transfer.save
										#Subscription Record
										subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
										if subscription_record == nil then
											subscription_record = SubscriptionRecord.new
											subscription_record.subscriber_id = subscription.subscriber_id
											subscription_record.subscribed_id = subscription.subscribed_id
											subscription_record.supporter_switch = subscription.supporter_switch
											subscription_record.accumulated_total = subscription.amount
											subscription_record.accumulated_receive = ( subscription.amount - @fee)
											subscription_record.accumulated_fee = @fee
											subscription_record.counter = subscription_record.counter+1
											subscription_record.save				
										else
											subscription_record.accumulated_total += subscription.amount
											subscription_record.accumulated_receive += ( subscription.amount - @fee)
											subscription_record.accumulated_fee += @fee									
											subscription_record.supporter_switch = subscription.supporter_switch
											subscription_record.counter += 1
											subscription_record.save
										end
										#Subscription
										subscription.accumulated_total += subscription.amount
										subscription.accumulated_receive += ( subscription.amount - @fee )
										subscription.accumulated_fee += @fee
										subscription.counter += 1
										subscription.subscription_record_id = subscription_record.id
										subscription.save
									end
								end
							end
							#Record Order
							@order.transacted = true
							@order.transacted_at = Time.now
							@order.save
							#Billing Subscription
							@billing_subscription = @subscriber.billing_subscription
							@billing_subscription.accumulated_total += transaction.total
							@billing_subscription.accumulated_payment_fee += transaction.fee
							@billing_subscription.accumulated_receive += transaction.receive
							#Send email to subscribed
							SubscriptionMailer.successful_order(@order.id).deliver
						else
							if @subscriber.billing_agreement != nil then
								#PayPal
								begin
									if Rails.env.development? then
										@request = Paypal::Express::Request.new(
							  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
							  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
							  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
										)	
									else
										@request = Paypal::Express::Request.new(
							  				:username   => ENV["PAYPAL_USERNAME"],
							  				:password   => ENV["PAYPAL_PASSWORD"],
							  				:signature  => ENV["PAYPAL_SIGNATURE"]
										)				
									end			
									response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscriber.order.amount.to_i
								rescue
									#Fail to process payment by PayPal
									#Send email
									SubscriptionMailer.fail_to_process_payment(@order.id,"PayPal").deliver
								end
								if response.ack == "Success" then
									#Record transaction
									transaction = Transaction.paypal!(
										response,
										:order_id => @order.id,
										:subscriber_id => @subscriber.id,
										:transaction_method => "PayPal"
									)
									#Record Transfer
									@fee = transaction.fee / @order.count if @order.count != 0
									@subscriber.reverse_subscriptions.each do |subscription| 
										subscribed = User.find(subscription.subscribed_id)
										if subscribed != nil && subscribed.transfer != nil then
											#If the subscribed has order this month
											if subscribed.transfer.ordered_amount != 0 then
												#Transfer
												transfer = subscribed.transfer
												transfer.collected_receive += ( subscription.amount - @fee)
												transfer.collected_amount += subscription.amount
												transfer.collected_fee += @fee
												transfer.save
												#Subscription Record
												subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
												if subscription_record == nil then
													subscription_record = SubscriptionRecord.new
													subscription_record.subscriber_id = subscription.subscriber_id
													subscription_record.subscribed_id = subscription.subscribed_id
													subscription_record.supporter_switch = subscription.supporter_switch
													subscription_record.accumulated_total = subscription.amount
													subscription_record.accumulated_receive = ( subscription.amount - @fee)
													subscription_record.accumulated_fee = @fee
													subscription_record.counter = subscription_record.counter+1
													subscription_record.save				
												else
													subscription_record.accumulated_total += subscription.amount
													subscription_record.accumulated_receive += ( subscription.amount - @fee)
													subscription_record.accumulated_fee += @fee									
													subscription_record.supporter_switch = subscription.supporter_switch
													subscription_record.counter += 1
													subscription_record.save
												end
												#Subscription
												subscription.accumulated_total += subscription.amount
												subscription.accumulated_receive += ( subscription.amount - @fee )
												subscription.accumulated_fee += @fee
												subscription.counter += 1
												subscription.subscription_record_id = subscription_record.id
												subscription.save
											end
										end
									end
									#Record Order
									@order.transacted = true
									@order.transacted_at = Time.now
									@order.save
									#Billing Subscription
									@billing_subscription = @subscriber.billing_subscription
									@billing_subscription.accumulated_total += transaction.total
									@billing_subscription.accumulated_payment_fee += transaction.fee
									@billing_subscription.accumulated_receive += transaction.receive
									#Send email to subscribed
									SubscriptionMailer.successful_order(@order.id).deliver
								else
									#Fail to process payment by PayPal and Card
									#Send email
									SubscriptionMailer.fail_to_process_payment(@order.id,"both").deliver
								end
							else
								#Fail to process payment by Card
								#Send email		
								SubscriptionMailer.fail_to_process_payment(@order.id,"Card").deliver
							end
						end						
					else
						#Email the subscriber about no billing method
						#Send email
						SubscriptionMailer.fail_to_process_payment(@order.id,"no").deliver
					end
				end
			end
		end		
	end

	def self.transact_order_final(order_id, user_id)
		@order = Order.find(order_id)
		@subscriber = User.find(user_id)
		if @subscriber.default_billing_method == "PayPal" then
			#PayPal
			begin
				if Rails.env.development? then
					@request = Paypal::Express::Request.new(
		  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
		  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
		  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
					)	
				else
					@request = Paypal::Express::Request.new(
		  				:username   => ENV["PAYPAL_USERNAME"],
		  				:password   => ENV["PAYPAL_PASSWORD"],
		  				:signature  => ENV["PAYPAL_SIGNATURE"]
					)				
				end			
				response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscriber.order.amount.to_i
			rescue
				#Fail to process payment by PayPal
				#Send email
				SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
				#Unsubscribe user
				Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
				#Destroy the order
				@order.deleted = true
				@order.deleted_at = Time.now
				@order.save
			end
			if response.ack == "Success" then
				#Record transaction
				transaction = Transaction.paypal!(
					response,
					:order_id => @order.id,
					:subscriber_id => @subscriber.id,
					:transaction_method => "PayPal"
				)
				#Record Transfer
				@fee = transaction.fee / @order.count if @order.count != 0
				@subscriber.reverse_subscriptions.each do |subscription| 
					subscribed = User.find(subscription.subscribed_id)
					if subscribed != nil && subscribed.transfer != nil then
						#If the subscribed has order this month
						if subscribed.transfer.ordered_amount != 0 then
							#Transfer
							transfer = subscribed.transfer
							transfer.collected_receive += ( subscription.amount - @fee)
							transfer.collected_amount += subscription.amount
							transfer.collected_fee += @fee
							transfer.save
							#Subscription Record
							subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
							if subscription_record == nil then
								subscription_record = SubscriptionRecord.new
								subscription_record.subscriber_id = subscription.subscriber_id
								subscription_record.subscribed_id = subscription.subscribed_id
								subscription_record.supporter_switch = subscription.supporter_switch
								subscription_record.accumulated_total = subscription.amount
								subscription_record.accumulated_receive = ( subscription.amount - @fee)
								subscription_record.accumulated_fee = @fee
								subscription_record.counter = subscription_record.counter+1
								subscription_record.save				
							else
								subscription_record.accumulated_total += subscription.amount
								subscription_record.accumulated_receive += ( subscription.amount - @fee)
								subscription_record.accumulated_fee += @fee									
								subscription_record.supporter_switch = subscription.supporter_switch
								subscription_record.counter += 1
								subscription_record.save
							end
							#Subscription
							subscription.accumulated_total += subscription.amount
							subscription.accumulated_receive += ( subscription.amount - @fee )
							subscription.accumulated_fee += @fee
							subscription.counter += 1
							subscription.subscription_record_id = subscription_record.id
							subscription.save
						end
					end
				end
				#Record Order
				@order.transacted = true
				@order.transacted_at = Time.now
				@order.save
				#Billing Subscription
				@billing_subscription = @subscriber.billing_subscription
				@billing_subscription.accumulated_total += transaction.total
				@billing_subscription.accumulated_payment_fee += transaction.fee
				@billing_subscription.accumulated_receive += transaction.receive
				#Send email to subscribed
				SubscriptionMailer.successful_order(@order.id).deliver
			else
				if @subscriber.cards.first != nil then
					#Card
					response = Stripe::Charge.create(
						:amount => @order.amount.to_i*100,
						:currency => "usd",
						:customer => @subscriber.customer.customer_id,
						:description => "Ratafire subscription fee of the month."
					)		
					if response.captured == true then
					#Record Transfer
					@fee = transaction.fee / @order.count if @order.count != 0
					@subscriber.reverse_subscriptions.each do |subscription| 
						subscribed = User.find(subscription.subscribed_id)
						if subscribed != nil then
							#Transfer
							if subscribed.transfer != nil then
								transfer = subscribed.transfer
							else
								transfer = Transfer.new
							end
							transfer.collected_receive += ( subscription.amount - @fee)
							transfer.collected_amount += subscription.amount
							transfer.collected_fee += @fee
							transfer.save
							#Subscription Record
							subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
							if subscription_record == nil then
								subscription_record = SubscriptionRecord.new
								subscription_record.subscriber_id = subscription.subscriber_id
								subscription_record.subscribed_id = subscription.subscribed_id
								subscription_record.supporter_switch = subscription.supporter_switch
								subscription_record.accumulated_total = subscription.amount
								subscription_record.accumulated_receive = ( subscription.amount - @fee)
								subscription_record.accumulated_fee = @fee
								subscription_record.counter = subscription_record.counter+1
								subscription_record.save				
							else
								subscription_record.accumulated_total += subscription.amount
								subscription_record.accumulated_receive += ( subscription.amount - @fee)
								subscription_record.accumulated_fee += @fee									
								subscription_record.supporter_switch = subscription.supporter_switch
								subscription_record.counter += 1
								subscription_record.save
							end
							#Subscription
							subscription.accumulated_total += subscription.amount
							subscription.accumulated_receive += ( subscription.amount - @fee )
							subscription.accumulated_fee += @fee
							subscription.counter += 1
							subscription.subscription_record_id = subscription_record.id
							subscription.save
						end
					end
					#Record Order
					@order.transacted = true
					@order.transacted_at = Time.now
					@order.save
					#Billing Subscription
					@billing_subscription = @subscriber.billing_subscription
					@billing_subscription.accumulated_total += transaction.total
					@billing_subscription.accumulated_payment_fee += transaction.fee
					@billing_subscription.accumulated_receive += transaction.receive
					#Send email to subscribed
					SubscriptionMailer.successful_order(@order.id).deliver						
					else
						#Fail to process payment by PayPal and Card
						#Send email
						SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
						#Unsubscribe user
						Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
						#Destroy the order
						@order.deleted = true
						@order.deleted_at = Time.now
						@order.save								
					end	
				else
					#Fail to process payment by PayPal
					#Send email
					SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
					#Unsubscribe user
					Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)	
					#Destroy the order
					@order.deleted = true
					@order.deleted_at = Time.now
					@order.save											
				end				
			end
		else
			if @subscriber.default_billing_method == "Card" then
				#Card
				begin
					response = Stripe::Charge.create(
						:amount => @order.amount.to_i*100,
						:currency => "usd",
						:customer => @subscriber.customer.customer_id,
						:description => "Ratafire subscription fee of the month."
					)
				rescue
					#Fail to process payment by Card
					#Send email
					SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
					#Unsubscribe user
					Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)	
					#Destroy the order
					@order.deleted = true
					@order.deleted_at = Time.now
					@order.save							
				end		
				if response.captured == true then
					#Record transaction
					transaction = Transaction.prefill!(
						response,
						:order_id => @order.id,
						:subscriber_id => @subscriber.id,
						:fee => @order.amount.to_f*0.029+0.30,
						:transaction_method => "Stripe"
					)
					#Record Transfer
					@fee = transaction.fee / @order.count if @order.count != 0
					@subscriber.reverse_subscriptions.each do |subscription| 
						subscribed = User.find(subscription.subscribed_id)
						if subscribed != nil then
							#Transfer
							if subscribed.transfer != nil then
								transfer = subscribed.transfer
							else
								transfer = Transfer.new
							end
							transfer.collected_receive += ( subscription.amount - @fee)
							transfer.collected_amount += subscription.amount
							transfer.collected_fee += @fee
							transfer.save
							#Subscription Record
							subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
							if subscription_record == nil then
								subscription_record = SubscriptionRecord.new
								subscription_record.subscriber_id = subscription.subscriber_id
								subscription_record.subscribed_id = subscription.subscribed_id
								subscription_record.supporter_switch = subscription.supporter_switch
								subscription_record.accumulated_total = subscription.amount
								subscription_record.accumulated_receive = ( subscription.amount - @fee)
								subscription_record.accumulated_fee = @fee
								subscription_record.counter = subscription_record.counter+1
								subscription_record.save				
							else
								subscription_record.accumulated_total += subscription.amount
								subscription_record.accumulated_receive += ( subscription.amount - @fee)
								subscription_record.accumulated_fee += @fee									
								subscription_record.supporter_switch = subscription.supporter_switch
								subscription_record.counter += 1
								subscription_record.save
							end
							#Subscription
							subscription.accumulated_total += subscription.amount
							subscription.accumulated_receive += ( subscription.amount - @fee )
							subscription.accumulated_fee += @fee
							subscription.counter += 1
							subscription.subscription_record_id = subscription_record.id
							subscription.save
						end
					end
					#Record Order
					@order.transacted = true
					@order.transacted_at = Time.now
					@order.save
					#Billing Subscription
					@billing_subscription = @subscriber.billing_subscription
					@billing_subscription.accumulated_total += transaction.total
					@billing_subscription.accumulated_payment_fee += transaction.fee
					@billing_subscription.accumulated_receive += transaction.receive
					#Send email to subscribed
					SubscriptionMailer.successful_order(@order.id).deliver
				else
					if @subscriber.billing_agreement != nil then
						#PayPal
						if Rails.env.development? then
							@request = Paypal::Express::Request.new(
				  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
				  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
				  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
							)	
						else
							@request = Paypal::Express::Request.new(
				  				:username   => ENV["PAYPAL_USERNAME"],
				  				:password   => ENV["PAYPAL_PASSWORD"],
				  				:signature  => ENV["PAYPAL_SIGNATURE"]
							)				
						end			
						response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscriber.order.amount.to_i
						if response.ack == "Success" then
							#Record transaction
							transaction = Transaction.paypal!(
								response,
								:order_id => @order.id,
								:subscriber_id => @subscriber.id,
								:transaction_method => "PayPal"
							)
							#Record Transfer
							@fee = transaction.fee / @order.count if @order.count != 0
							@subscriber.reverse_subscriptions.each do |subscription| 
								subscribed = User.find(subscription.subscribed_id)
								if subscribed != nil then
									#Transfer
									if subscribed.transfer != nil then
										transfer = subscribed.transfer
									else
										transfer = Transfer.new
									end
									transfer.collected_receive += ( subscription.amount - @fee)
									transfer.collected_amount += subscription.amount
									transfer.collected_fee += @fee
									transfer.save
									#Subscription Record
									subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
									if subscription_record == nil then
										subscription_record = SubscriptionRecord.new
										subscription_record.subscriber_id = subscription.subscriber_id
										subscription_record.subscribed_id = subscription.subscribed_id
										subscription_record.supporter_switch = subscription.supporter_switch
										subscription_record.accumulated_total = subscription.amount
										subscription_record.accumulated_receive = ( subscription.amount - @fee)
										subscription_record.accumulated_fee = @fee
										subscription_record.counter = subscription_record.counter+1
										subscription_record.save				
									else
										subscription_record.accumulated_total += subscription.amount
										subscription_record.accumulated_receive += ( subscription.amount - @fee)
										subscription_record.accumulated_fee += @fee									
										subscription_record.supporter_switch = subscription.supporter_switch
										subscription_record.counter += 1
										subscription_record.save
									end
									#Subscription
									subscription.accumulated_total += subscription.amount
									subscription.accumulated_receive += ( subscription.amount - @fee )
									subscription.accumulated_fee += @fee
									subscription.counter += 1
									subscription.subscription_record_id = subscription_record.id
									subscription.save
								end
							end
							#Record Order
							@order.transacted = true
							@order.transacted_at = Time.now
							@order.save
							#Billing Subscription
							@billing_subscription = @subscriber.billing_subscription
							@billing_subscription.accumulated_total += transaction.total
							@billing_subscription.accumulated_payment_fee += transaction.fee
							@billing_subscription.accumulated_receive += transaction.receive
							#Send email to subscribed
							SubscriptionMailer.successful_order(@order.id).deliver
						else
							#Fail to process payment by PayPal and Card
							#Send email
							SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
							#Unsubscribe user
							Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
							#Destroy the order
							@order.deleted = true
							@order.deleted_at = Time.now
							@order.save									
						end
					else
						#Fail to process payment by Card
						#Send email
						SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
						#Unsubscribe user
						Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
						#Destroy the order
						@order.deleted = true
						@order.deleted_at = Time.now
						@order.save								
					end
				end						
			else
				if @subscriber.billing_agreement != nil then
					begin
						#PayPal
						if Rails.env.development? then
							@request = Paypal::Express::Request.new(
				  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
				  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
				  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
							)	
						else
							@request = Paypal::Express::Request.new(
				  				:username   => ENV["PAYPAL_USERNAME"],
				  				:password   => ENV["PAYPAL_PASSWORD"],
				  				:signature  => ENV["PAYPAL_SIGNATURE"]
							)				
						end			
						response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscriber.order.amount.to_i
					rescue
						#Fail to process payment by PayPal
						#Send email
						SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
						#Unsubscribe user
						Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)		
						#Destroy the order
						@order.deleted = true
						@order.deleted_at = Time.now
						@order.save														
					end
					if response.ack == "Success" then
						#Record transaction
						transaction = Transaction.paypal!(
							response,
							:order_id => @order.id,
							:subscriber_id => @subscriber.id,
							:transaction_method => "PayPal"
						)
						#Record Transfer
						@fee = transaction.fee / @order.count if @order.count != 0
						@subscriber.reverse_subscriptions.each do |subscription| 
							subscribed = User.find(subscription.subscribed_id)
							if subscribed != nil then
								#Transfer
								if subscribed.transfer != nil then
									transfer = subscribed.transfer
								else
									transfer = Transfer.new
								end
								transfer.collected_receive += ( subscription.amount - @fee)
								transfer.collected_amount += subscription.amount
								transfer.collected_fee += @fee
								transfer.save
								#Subscription Record
								subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
								if subscription_record == nil then
									subscription_record = SubscriptionRecord.new
									subscription_record.subscriber_id = subscription.subscriber_id
									subscription_record.subscribed_id = subscription.subscribed_id
									subscription_record.supporter_switch = subscription.supporter_switch
									subscription_record.accumulated_total = subscription.amount
									subscription_record.accumulated_receive = ( subscription.amount - @fee)
									subscription_record.accumulated_fee = @fee
									subscription_record.counter = subscription_record.counter+1
									subscription_record.save				
								else
									subscription_record.accumulated_total += subscription.amount
									subscription_record.accumulated_receive += ( subscription.amount - @fee)
									subscription_record.accumulated_fee += @fee									
									subscription_record.supporter_switch = subscription.supporter_switch
									subscription_record.counter += 1
									subscription_record.save
								end
								#Subscription
								subscription.accumulated_total += subscription.amount
								subscription.accumulated_receive += ( subscription.amount - @fee )
								subscription.accumulated_fee += @fee
								subscription.counter += 1
								subscription.subscription_record_id = subscription_record.id
								subscription.save
							end
						end
						#Record Order
						@order.transacted = true
						@order.transacted_at = Time.now
						@order.save
						#Billing Subscription
						@billing_subscription = @subscriber.billing_subscription
						@billing_subscription.accumulated_total += transaction.total
						@billing_subscription.accumulated_payment_fee += transaction.fee
						@billing_subscription.accumulated_receive += transaction.receive
						#Send email to subscribed
						SubscriptionMailer.successful_order(@order.id).deliver
					else
						if @subscriber.cards.first != nil then
							#Card
							begin
								response = Stripe::Charge.create(
									:amount => @order.amount.to_i*100,
									:currency => "usd",
									:customer => @subscriber.customer.customer_id,
									:description => "Ratafire subscription fee of the month."
								)		
							rescue
								#Fail to process payment by Card
								#Send email
								SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
								#Unsubscribe user
								Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
								#Destroy the order
								@order.deleted = true
								@order.deleted_at = Time.now
								@order.save										
							end
							if response.captured == true then
								#Record transaction
								transaction = Transaction.prefill!(
									response,
									:order_id => @order.id,
									:subscriber_id => @subscriber.id,
									:fee => @order.amount.to_f*0.029+0.30,
									:transaction_method => "Stripe"
								)
								#Record Transfer
								@fee = transaction.fee / @order.count if @order.count != 0
								@subscriber.reverse_subscriptions.each do |subscription| 
									subscribed = User.find(subscription.subscribed_id)
									if subscribed != nil then
										#Transfer
										if subscribed.transfer != nil then
											transfer = subscribed.transfer
										else
											transfer = Transfer.new
										end
										transfer.collected_receive += ( subscription.amount - @fee)
										transfer.collected_amount += subscription.amount
										transfer.collected_fee += @fee
										transfer.save
										#Subscription Record
										subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
										if subscription_record == nil then
											subscription_record = SubscriptionRecord.new
											subscription_record.subscriber_id = subscription.subscriber_id
											subscription_record.subscribed_id = subscription.subscribed_id
											subscription_record.supporter_switch = subscription.supporter_switch
											subscription_record.accumulated_total = subscription.amount
											subscription_record.accumulated_receive = ( subscription.amount - @fee)
											subscription_record.accumulated_fee = @fee
											subscription_record.counter = subscription_record.counter+1
											subscription_record.save				
										else
											subscription_record.accumulated_total += subscription.amount
											subscription_record.accumulated_receive += ( subscription.amount - @fee)
											subscription_record.accumulated_fee += @fee									
											subscription_record.supporter_switch = subscription.supporter_switch
											subscription_record.counter += 1
											subscription_record.save
										end
										#Subscription
										subscription.accumulated_total += subscription.amount
										subscription.accumulated_receive += ( subscription.amount - @fee )
										subscription.accumulated_fee += @fee
										subscription.counter += 1
										subscription.subscription_record_id = subscription_record.id
										subscription.save
									end
								end
								#Record Order
								@order.transacted = true
								@order.transacted_at = Time.now
								@order.save
								#Billing Subscription
								@billing_subscription = @subscriber.billing_subscription
								@billing_subscription.accumulated_total += transaction.total
								@billing_subscription.accumulated_payment_fee += transaction.fee
								@billing_subscription.accumulated_receive += transaction.receive
								#Send email to subscribed
								SubscriptionMailer.successful_order(@order.id).deliver						
							else
								#Fail to process payment by PayPal and Card
								#Send email
								SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
								#Unsubscribe user
								Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
								#Destroy the order
								@order.deleted = true
								@order.deleted_at = Time.now
								@order.save										
							end	
						else
							#Fail to process payment by PayPal
							#Send email
							SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
							#Unsubscribe user
							Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)	
							#Destroy the order
							@order.deleted = true
							@order.deleted_at = Time.now
							@order.save												
						end				
					end
				else
					if @subscriber.cards.first != nil then
						#Card
						begin
							response = Stripe::Charge.create(
								:amount => @order.amount.to_i*100,
								:currency => "usd",
								:customer => @subscriber.customer.customer_id,
								:description => "Ratafire subscription fee of the month."
							)	
						rescue
							#Fail to process payment by Card
							#Send email
							SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
							#Unsubscribe user
							Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
							#Destroy the order
							@order.deleted = true
							@order.deleted_at = Time.now
							@order.save									
						end	
						if response.captured == true then
							#Record transaction
							transaction = Transaction.prefill!(
								response,
								:order_id => @order.id,
								:subscriber_id => @subscriber.id,
								:fee => @order.amount.to_f*0.029+0.30,
								:transaction_method => "Stripe"
							)
							#Record Transfer
							@fee = transaction.fee / @order.count if @order.count != 0
							@subscriber.reverse_subscriptions.each do |subscription| 
								subscribed = User.find(subscription.subscribed_id)
								if subscribed != nil then
									#Transfer
									if subscribed.transfer != nil then
										transfer = subscribed.transfer
									else
										transfer = Transfer.new
									end
									transfer.collected_receive += ( subscription.amount - @fee)
									transfer.collected_amount += subscription.amount
									transfer.collected_fee += @fee
									transfer.save
									#Subscription Record
									subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
									if subscription_record == nil then
										subscription_record = SubscriptionRecord.new
										subscription_record.subscriber_id = subscription.subscriber_id
										subscription_record.subscribed_id = subscription.subscribed_id
										subscription_record.supporter_switch = subscription.supporter_switch
										subscription_record.accumulated_total = subscription.amount
										subscription_record.accumulated_receive = ( subscription.amount - @fee)
										subscription_record.accumulated_fee = @fee
										subscription_record.counter = subscription_record.counter+1
										subscription_record.save				
									else
										subscription_record.accumulated_total += subscription.amount
										subscription_record.accumulated_receive += ( subscription.amount - @fee)
										subscription_record.accumulated_fee += @fee									
										subscription_record.supporter_switch = subscription.supporter_switch
										subscription_record.counter += 1
										subscription_record.save
									end
									#Subscription
									subscription.accumulated_total += subscription.amount
									subscription.accumulated_receive += ( subscription.amount - @fee )
									subscription.accumulated_fee += @fee
									subscription.counter += 1
									subscription.subscription_record_id = subscription_record.id
									subscription.save
								end
							end
							#Record Order
							@order.transacted = true
							@order.transacted_at = Time.now
							@order.save
							#Billing Subscription
							@billing_subscription = @subscriber.billing_subscription
							@billing_subscription.accumulated_total += transaction.total
							@billing_subscription.accumulated_payment_fee += transaction.fee
							@billing_subscription.accumulated_receive += transaction.receive
							#Send email to subscribed
							SubscriptionMailer.successful_order(@order.id).deliver
						else
							if @subscriber.billing_agreement != nil then
								#PayPal
								begin
									if Rails.env.development? then
										@request = Paypal::Express::Request.new(
							  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
							  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
							  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
										)	
									else
										@request = Paypal::Express::Request.new(
							  				:username   => ENV["PAYPAL_USERNAME"],
							  				:password   => ENV["PAYPAL_PASSWORD"],
							  				:signature  => ENV["PAYPAL_SIGNATURE"]
										)				
									end			
									response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscriber.order.amount.to_i
								rescue
									#Fail to process payment by PayPal
									#Send email
									SubscriptionMailer.fail_to_process_payment(@order.id,"PayPal").deliver
									#Unsubscribe user
									Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
									#Destroy the order
									@order.deleted = true
									@order.deleted_at = Time.now
									@order.save		
								end
								if response.ack == "Success" then
									#Record transaction
									transaction = Transaction.paypal!(
										response,
										:order_id => @order.id,
										:subscriber_id => @subscriber.id,
										:transaction_method => "PayPal"
									)
									#Record Transfer
									@fee = transaction.fee / @order.count if @order.count != 0
									@subscriber.reverse_subscriptions.each do |subscription| 
										subscribed = User.find(subscription.subscribed_id)
										if subscribed != nil then
											#Transfer
											if subscribed.transfer != nil then
												transfer = subscribed.transfer
											else
												transfer = Transfer.new
											end
											transfer.collected_receive += ( subscription.amount - @fee)
											transfer.collected_amount += subscription.amount
											transfer.collected_fee += @fee
											transfer.save
											#Subscription Record
											subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
											if subscription_record == nil then
												subscription_record = SubscriptionRecord.new
												subscription_record.subscriber_id = subscription.subscriber_id
												subscription_record.subscribed_id = subscription.subscribed_id
												subscription_record.supporter_switch = subscription.supporter_switch
												subscription_record.accumulated_total = subscription.amount
												subscription_record.accumulated_receive = ( subscription.amount - @fee)
												subscription_record.accumulated_fee = @fee
												subscription_record.counter = subscription_record.counter+1
												subscription_record.save				
											else
												subscription_record.accumulated_total += subscription.amount
												subscription_record.accumulated_receive += ( subscription.amount - @fee)
												subscription_record.accumulated_fee += @fee									
												subscription_record.supporter_switch = subscription.supporter_switch
												subscription_record.counter += 1
												subscription_record.save
											end
											#Subscription
											subscription.accumulated_total += subscription.amount
											subscription.accumulated_receive += ( subscription.amount - @fee )
											subscription.accumulated_fee += @fee
											subscription.counter += 1
											subscription.subscription_record_id = subscription_record.id
											subscription.save
										end
									end
									#Record Order
									@order.transacted = true
									@order.transacted_at = Time.now
									@order.save
									#Billing Subscription
									@billing_subscription = @subscriber.billing_subscription
									@billing_subscription.accumulated_total += transaction.total
									@billing_subscription.accumulated_payment_fee += transaction.fee
									@billing_subscription.accumulated_receive += transaction.receive
									#Send email to subscribed
									SubscriptionMailer.successful_order(@order.id).deliver
								else
									#Fail to process payment by PayPal and Card
									#Send email
									SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
									#Unsubscribe user
									Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
									#Destroy the order
									@order.deleted = true
									@order.deleted_at = Time.now
									@order.save													
								end
							else
								#Fail to process payment by Card
								#Send email
								SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
								#Unsubscribe user
								Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
								#Destroy the order
								@order.deleted = true
								@order.deleted_at = Time.now
								@order.save		
							end
						end						
					else
						#Email the subscriber about no billing method
						#Send email
						SubscriptionMailer.final_fail_to_process_payment(@order.id).deliver							
						#Unsubscribe user
						Resque.enqueue(UnsubscribeWorker, @subscriber.id,3)
						#Destroy the order
						@order.deleted = true
						@order.deleted_at = Time.now
						@order.save										
					end
				end
			end
		end				
	end

	def self.record_transfer
	end
end
