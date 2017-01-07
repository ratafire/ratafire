class Payment::CardsController < ActionController::Base

	#Before filters
	before_filter :load_user
	before_filter :connect_to_stripe, only:[:create, :destroy]

	#REST Methods -----------------------------------

	# user_payment_cards POST
	# /users/:user_id/payment/cards
	def create
		@card = Card.new(card_params)
		@card.last4 = @card.card_number.to_s.split(//).last(4).join("").to_s
		add_a_card
	rescue Stripe::CardError => e
		# Since it's a decline, Stripe::CardError will be caught
		body = e.json_body
		err  = body[:error]

		puts "Status is: #{e.http_status}"
		puts "Type is: #{err[:type]}"
		puts "Code is: #{err[:code]}"
		# param is '' in this case
		puts "Param is: #{err[:param]}"
		puts "Message is: #{err[:message]}"
		#Show to the user
		flash[:error] = "#{err[:message]}"
		redirect_to(:back)
	rescue Stripe::RateLimitError => e
		# Too many requests made to the API too quickly
		flash[:error] = t('errors.messages.too_many_requests')
		redirect_to(:back)
	rescue Stripe::InvalidRequestError => e
		# Invalid parameters were supplied to Stripe's API
		flash[:error] = t('errors.messages.not_saved')
		redirect_to(:back)
	rescue Stripe::AuthenticationError => e
		# Authentication with Stripe's API failed
		# (maybe you changed API keys recently)
		flash[:error] = t('errors.messages.not_saved')
		redirect_to(:back)
	rescue Stripe::APIConnectionError => e
		# Network communication with Stripe failed
		flash[:error] = t('errors.messages.not_saved')
		redirect_to(:back)
	rescue Stripe::StripeError => e
		# Display a very generic error to the user, and maybe send
		# yourself an email
		flash[:error] = t('errors.messages.not_saved')
		redirect_to(:back)
	rescue 
		# General rescue
		redirect_to(:back)
		flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
	end

	# user_payment_cards PATCH
	# /users/:user_id/payment/cards
	def update
		@card = Card.new(card_params)
		@card.last4 = @card.card_number.to_s.split(//).last(4).join("").to_s
		add_a_card
	rescue
		redirect_to(:back)
	end

	# user_payment_cards DELETE
	# /users/:user_id/payment/cards
	def destroy
		@card = @user.card
		#Retrieve stripe customer
		@customer = Stripe::Customer.retrieve(@user.customer.customer_id)
		#Delete the card on stripe
		#@customer.sources.retrieve(@card.card_stripe_id).delete
		@customer.sources.each do |source|
			source.delete
		end
		#Delete the card
		@card.destroy
		#Create a new card
		@card = Card.new
	rescue
		#Delete the card
		@card.destroy
		#Create a new card
		@card = Card.new
	end


	#NoREST Methods -----------------------------------

	# edit_user_payment_cards GET
	# /users/:user_id/payment/cards/edit
	def edit
		@card = @user.card
	end	

private

	def add_a_card
		if @stripe_token = Stripe::Token.create(
				:card => {
					:number => @card.card_number,
					:exp_month => @card.exp_month,
					:exp_year => @card.exp_year,
					:cvc => @card.cvc
				},
			)
			if @user.customer
				@customer = Stripe::Customer.retrieve(@user.customer.customer_id)
				if @customer.sources.create(:source => @stripe_token)
					update_card
				else
					flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
					redirect_to(:back)
				end
			else
				if @customer = Stripe::Customer.create(
					:source => @stripe_token
					)
					@user_customer = Customer.prefill!(@customer, @user.id)
					@user_customer = Customer.find_by_user_id(@user.id)
					if @customer = Stripe::Customer.retrieve(@user_customer.customer_id)
						update_card
					else
						flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
						redirect_to(:back)
					end
				else
					flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
					redirect_to(:back)
				end
			end
		else
			flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
			redirect_to(:back)
		end
	end

	def update_card
		if @card.update(
			card_stripe_id: @customer.sources.first.id,
			brand: @customer.sources.first.brand,
			address_zip_check:  @customer.sources.first.address_zip_check,
			cvc_check:  @customer.sources.first.cvc_check,
			funding:  @customer.sources.first.funding,
			customer_stripe_id:  @customer.id
		)
			if @user.card
				#retrieve old and new stripe 
				@new_card = @customer.sources.retrieve(@card.card_stripe_id)
				#Make new as default
				@customer.default_source = @new_card.id
				@customer.save
				#delete old
				if @old_card = @customer.sources.retrieve(@user.card.card_stripe_id)
					@old_card.delete
				end
				@user.card.destroy
			end
			@card.user_id = @user.id
			@card.save
			#render js
		else
			redirect_to(:back)
		end
	rescue
		@user.card.destroy
		@card.user_id = @user.id
		@card.save
	end


	def card_params
		params.require(:card).permit(:name, :card_number, :cvc, :exp_month, :exp_year, :country, :address_city, :address_line1, :address_zip)
	end

	def connect_to_stripe
		if Rails.env.production?
			Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		else
			Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
		end
	end

	def load_user
		#Load user by username due to FriendlyID
		if @user = User.find_by_username(params[:user_id])
		else
			@user = current_user
		end
	end			

end