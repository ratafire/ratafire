class Payment::PaypalAccountsController < ActionController::Base

	#Before filters
	before_filter :load_user

	#REST Methods -----------------------------------

	# user_payment_paypal_accounts POST
	# /users/:user_id/payment/paypal_accounts
	def create
		if @user.paypal_account
			@paypal_account = @user.paypal_account
			@paypal_account.update(
				paypal_account_params
			)
		else
			@paypal_account = PaypalAccount.create(paypal_account_params)
		end
	rescue
	 	flash[:error] = t('errors.messages.not_saved')
	 	redirect_to(:back)	
	end

	# user_payment_paypal_accounts PATCH
	# /users/:user_id/payment/paypal_accounts
	def update
		if @user.paypal_account
			@paypal_account = @user.paypal_account
			@paypal_account.update(
				paypal_account_params
			)
		else
			@paypal_account = PaypalAccount.create(paypal_account_params)
		end
	rescue
	 	flash[:error] = t('errors.messages.not_saved')
	 	redirect_to(:back)
	end

	#NoREST Methods -----------------------------------

	# edit_user_payment_paypal_accounts GET
	# /users/:user_id/payment/paypal_accounts/edit
	def edit
		@paypal_account = @user.paypal_account
	end

	# create_campaign_user_payment_paypal_accounts GET
	# /users/:user_id/payment/paypal_accounts/create_campaign
	def create_campaign
	end

	# update_campaign_user_payment_paypal_accounts PATCH
	# /users/:user_id/payment/paypal_accounts/update_campaign
	def update_campaign
	end

	# edit_campaign_user_payment_paypal_accounts GET
	# /users/:user_id/payment/paypal_accounts/edit_campaign
	def edit_campaign
	end

private

	def load_user
		#Load user by username due to FriendlyID
		if @user = User.find_by_username(params[:user_id])
		else
			@user = current_user
		end
	end

	def paypal_account_params
		params.require(:paypal_account).permit(:user_id, :email)
	end	

end