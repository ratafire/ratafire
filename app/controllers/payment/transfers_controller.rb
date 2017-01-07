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

private

	def load_user
		@user = User.find(params[:user_id])
	end

	def transfer_params
		params.require(:transfer).permit(:user_id, :amount, :status)
	end

end