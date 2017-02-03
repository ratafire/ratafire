class Payment::TransfersController < ApplicationController

	before_filter :load_user

	#REST Methods -----------------------------------	

	# user_payment_transfers POST
	# /users/:user_id/payment/transfers
	def create
		@stripe_account = StripeAccount.find_by_user_id(@user.id)
		@transfer = Transfer.create(
			user_id: @user.id,
			amount: params[:transfer][:amount],
			status: "Pending"
		)
		Transfer.make_transfer(@transfer.id, @stripe_account.stripe_id)
		redirect_to(:back)
	end

	#noREST Methods -----------------------------------	

	# tansfer_datatable_user_payment_transfers GET
	# /users/:user_id/payment/transfers/transfer_datatable(.:format)
	def transfer_datatable
		respond_to do |format|
			format.html
			format.json { render json: TransferDatatable.new(view_context) }
		end
	end

	# transfer_schedule_user_payment_transfers POST
	# /users/:user_id/payment/transfers/transfer_schedule(.:format)
	def transfer_schedule
		if @stripe_account = StripeAccount.find_by_user_id(@user.id)
			if params[:stripe_account][:transfer_schedule_interval] != @stripe_account.transfer_schedule_interval
				#Establish stripe connection
				connect_to_stripe
				#Retrive account
				if @stripeaccount = Stripe::Account.retrieve(@stripe_account.stripe_id)
					#Set remote stripe account
					@stripeaccount.transfer_schedule.interval = params[:stripe_account][:transfer_schedule_interval]
					case params[:stripe_account][:transfer_schedule_interval]
					when 'weekly'
						@stripeaccount.transfer_schedule.weekly_anchor = "monday"
					when 'monthly'
						@stripeaccount.transfer_schedule.monthly_anchor = 1
					end
					@stripeaccount.save
					#Set local stripe account
					@stripe_account.update(
						transfer_schedule_interval: @stripeaccount.transfer_schedule.interval
					)
				end
			end
		end
	rescue
		flash[:error] = t('errors.messages.not_saved')
	end

private

	def load_user
		@user = User.find(params[:user_id])
	end

	def transfer_params
		params.require(:transfer).permit(:user_id, :amount, :status)
	end

	def connect_to_stripe
		if Rails.env.production?
			Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		else
			Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
		end
	end			

end