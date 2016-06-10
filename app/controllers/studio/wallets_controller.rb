class Studio::WalletsController < ApplicationController
	layout 'studio'

	#Before filters
	before_filter :load_user

	#how_i_get_paid_user_studio_wallet GET
	#/users/:user_id/studio/wallet/how_i_pay
	def how_i_pay
		if @user.card
			@card = @user.card
		else
			@card = Card.new
		end
	end

	#how_i_get_paid_user_studio_wallet GET
	#/users/:user_id/studio/wallet/how_i_get_paid
	def how_i_get_paid
		if @user.bank_account
			@bank_account = @user.bank_account
		else
			@bank_account = BankAccount.new
		end
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:user_id])
	end	

end