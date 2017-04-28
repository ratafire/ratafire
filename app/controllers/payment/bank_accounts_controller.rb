class Payment::BankAccountsController < ActionController::Base

	#Before filters
	before_filter :load_user
	before_filter :connect_to_stripe, only:[:create, :update]

	#REST Methods -----------------------------------

	# user_payment_bank_accounts POST
	# /users/:user_id/payment/bank_accounts
	def create
		@bank_account = BankAccount.new(bank_account_params)
		@bank_account.last4 = @bank_account.account_number.to_s.split(//).last(4).join("").to_s
		#Check if the user has entered a correct US postal code
		check_us_postal_code_and_create_bank_account
	rescue
	 	flash[:error] = t('errors.messages.not_saved')
	 	redirect_to(:back)		
	end

	# user_payment_bank_accounts PATCH
	# /users/:user_id/payment/bank_accounts
	def update
		@bank_account = BankAccount.new(bank_account_params)
		@bank_account.last4 = @bank_account.account_number.to_s.split(//).last(4).join("").to_s
		check_us_postal_code_and_create_bank_account
	rescue
	 	flash[:error] = t('errors.messages.not_saved')
	 	redirect_to(:back)		
	end

	# user_payment_bank_accounts DELETE
	# /users/:user_id/payment/bank_accounts
	def destroy
	end


	#NoREST Methods -----------------------------------

	# edit_user_payment_bank_accounts GET
	# /users/:user_id/payment/bank_accounts/edit
	def edit
		@bank_account = @user.bank_account
	end

private

	def check_us_postal_code_and_create_bank_account
		#Check if the user has entered a correct US postal code
		currency
		if @bank_account.country == "US"
			if @zipcodes = ZipCodes.identify(@bank_account.postal_code)
				@bank_account.state = @zipcodes[:state_code]
				create_bank_account
			else
				redirect_to(:back)
			end
		else
			create_bank_account
		end
	end

	def create_bank_account
		#Check if is same country as identity verification
		if @identity_verification = @user.identity_verification
			if @bank_account.first_name != @identity_verification.first_name || @bank_account.last_name != @identity_verification.last_name || @bank_account.country != @identity_verification.country
				#This person is lying, send back
				if I18n.locale == :zh
					flash[:error] = t('activerecord.attributes.user.lastname')+t('activerecord.attributes.user.firstname')+t('errors.messages.not_matched')
				else
					flash[:error] = t('activerecord.attributes.user.firstname')+' and '+t('activerecord.attributes.user.lastname')+ ' ' + t('errors.messages.not_matched')
				end
				redirect_to(:back)
			else
				create_bank_account_through_stripe
			end
		else
			create_bank_account_through_stripe
		end
	end

	def create_bank_account_through_stripe
		#Create stripe token
		if @stripe_token = Stripe::Token.create(
			    :bank_account => {
			    :currency => @currency,
			    :country => @bank_account.country,
			    :account_holder_name => @bank_account.first_name + " " + @bank_account.last_name,
			    :account_holder_type => "individual",
			    :routing_number => @bank_account.routing_number,
			    :account_number => @bank_account.account_number,
			    :default_for_currency => true
			  	},
			)
			if @user.stripe_account
				#Update user stripe account
				if @stripe_account = Stripe::Account.retrieve(@user.stripe_account.stripe_id)
					#Update stripe account
					@stripe_account.legal_entity.address.city = @bank_account.city
					@stripe_account.legal_entity.address.country = @bank_account.country
					@stripe_account.legal_entity.address.line1 = @bank_account.line1
					if @bank_account.country == 'US'
						@stripe_account.legal_entity.address.state = @bank_account.state
					end
					@stripe_account.legal_entity.address.postal_code = @bank_account.postal_code
					@stripe_account.save
					if @stripe_account.external_accounts.create(:external_account => @stripe_token.id)
						#Save bank account and redirect
						@stripe_account = Stripe::Account.retrieve(@user.stripe_account.stripe_id)
						update_bank_account
					else
						redirect_to(:back)
					end
				else
					redirect_to(:back)
				end
			else
				#Create user stripe account
				if @stripe_account = Stripe::Account.create(
						:managed => true,
						:country => @bank_account.country,
						:legal_entity => {
							:type => 'individual',
							:first_name => @bank_account.first_name,
							:last_name => @bank_account.last_name,
							:address => {
								:city => @bank_account.city,
								:country => @bank_account.country,
								:line1 => @bank_account.line1,
								:postal_code => @bank_account.postal_code
							}
						},
					:tos_acceptance => {
						:date => Time.now.to_time.to_i,
						:ip => request.remote_ip
						},
					:transfer_schedule => {
					    :interval => "manual"
					},	
				)
					if @bank_account.country == 'US'
						@stripe_account.legal_entity.address.state = @bank_account.state
						@stripe_account.save
					end
					if @stripe_account.transfer_schedule.interval != "manual"
						@stripe_account.transfer_schedule.interval = "manual"
						@stripe_account.save
					end
					#Create user stripe account
					@user_stripe_account = StripeAccount.stripe_account_create(@stripe_account, @user.id)						
					#Save bank account and redirect
					if @stripe_account.external_accounts.create(:external_account => @stripe_token.id)
						#Save bank account and redirect
						@stripe_account = Stripe::Account.retrieve(@user_stripe_account.stripe_id)
						update_bank_account
					else
						redirect_to(:back)
					end
				else
					redirect_to(:back)
				end
			end
		else
			redirect_to(:back)
		end
	end

	def update_bank_account
		if @bank_account.update(
				currency: @stripe_account.external_accounts.first.currency,
				status: @stripe_account.external_accounts.first.status,
				bank_name: @stripe_account.external_accounts.first.bank_name,
				stripe_id: @stripe_account.external_accounts.first.id
			)
			if @user.bank_account
				#retrieve old and new stripe 
				@new_external_account = @stripe_account.external_accounts.retrieve(@bank_account.stripe_id)
				#Make new as default
				@new_external_account.default_for_currency = true
				@new_external_account.save
				#delete old
				@old_external_account = @stripe_account.external_accounts.retrieve(@user.bank_account.stripe_id)
				@old_external_account.delete
				@user.bank_account.destroy
			end
			@bank_account.user_id = @user.id
			@bank_account.save
			create_bank_account_redirect
		else
			redirect_to(:back)
		end
	end

	def create_bank_account_redirect
		if @user.campaigns.count > 0 
			redirect_to apply_user_studio_campaigns_path(@user.username, @user.campaigns.first)
		else
			redirect_to(:back)
		end
	end

	def connect_to_stripe
		if Rails.env.production?
			Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		else
			Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
		end
	end
	
	def bank_account_params
		params.require(:bank_account).permit(:user_id,:stripe_id, :first_name, :last_name, :routing_number, :account_number, :country, :city, :line1, :postal_code)
	end

	def load_user
		#Load user by username due to FriendlyID
		if @user = User.find_by_username(params[:user_id])
		else
			@user = current_user
		end
	end		

	def currency
		case @bank_account.country
		when 'US'
			@currency = "USD"
		when 'AU'
			@currency = "AUD"
		when 'CA'
			@currency = "CAD"
		when 'DK'
			@currency = "DKK"
		when 'FI'
			@currency = "EUR"
		when 'IE'
			@currency = "EUR"
		when 'NO'
			@currency = "NOK"
		when 'SE'
			@currency = "SEK"
		when 'GB'
			@currency = "GBP"
		when 'AT'
			@currency = "EUR"
		when 'BE'
			@currency = "EUR"
		when 'DE'
			@currency = "EUR"
		when 'IT'
			@currency = "EUR"
		when 'JP'
			@currency = "JPY"
		when 'LU'
			@currency = "EUR"
		when 'NL'
			@currency = "EUR"
		when 'SG'
			@currency = "SGD"
		when 'ES'
			@currency = "EUR"
		when 'FR'
			@currency = "EUR"
		when 'HK'
			@currency = "HKD"
		when 'NZ'
			@currency = "NZD"
		end
	end	

end