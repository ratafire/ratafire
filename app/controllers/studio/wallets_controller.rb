class Studio::WalletsController < ApplicationController
	layout 'studio'

	#Before filters
	before_filter :authenticate_user!	
	before_filter :load_user
	before_filter :correct_user	

	#how_i_get_paid_user_studio_wallets GET
	#/users/:user_id/studio/wallet/how_i_pay
	def how_i_pay
		if @user.card
			@card = @user.card
		else
			@card = Card.new
		end
	end

	#how_i_get_paid_user_studio_wallets GET
	#/users/:user_id/studio/wallet/how_i_get_paid
	def how_i_get_paid
		if @user.bank_account
			@bank_account = @user.bank_account
		else
			@bank_account = BankAccount.new
		end
	end

	#upcoming_user_studio_wallets GET
	#/users/:user_id/studio/wallet/upcoming
	def upcoming
		unless @user.try(:order) && @user.try(:order).try(:status) != 'Started' 
			redirect_to campaigns_user_studio_creator_studio_path(current_user.username)
		end
	end

	#upcoming_datatable_user_studio_wallets GET 
	#/users/:user_id/studio/wallet/upcoming_datatable
	def upcoming_datatable
		respond_to do |format|
			format.html
			format.json { render json: UpcomingDatatable.new(view_context) }
		end
	end

	#receipts_user_studio_wallets GET
	#/users/:user_id/studio/wallet/receipts
	def receipts
		@transactions = @user.transactions.page(params[:page]).per_page(5)
	end

	#single_receipt_user_studio_wallets GET
	#/users/:user_id/studio/wallet/single_receipt/:transaction_id
	def single_receipt
		@transaction = Transaction.find_by_uuid(params[:transaction_id])
	end

	def single_receipt_datatable
		respond_to do |format|
			format.html
			format.json { render json: ReceiptDatatable.new(view_context) }
		end
	end

	#transfers_user_studio_wallets GET
	#/users/:user_id/studio/wallet/transfers
	def transfers
		@transfers = @user.transfer_transfered.page(params[:page]).per_page(5)
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def correct_user
		if current_user != @user 
			if @user.admin
			else
				redirect_to root_path
			end
		else
			
		end
	end	

end