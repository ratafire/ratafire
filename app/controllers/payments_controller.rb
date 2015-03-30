class PaymentsController < ApplicationController
	#rescue_from Paypal::Exception::APIError, with: :paypal_api_error
	#require 'paypal-sdk-permissions'

	#Create Billing Agreement with Paypal
	def create_billing_agreement
		#Find the user
		@user = User.find(params[:id])
		#Destry existed paypal billing agreement
		if @user.billing_agreement != nil then
			@user.billing_agreement.deleted = true
			@user.billing_agreement.save
		end
		#Create a new billing agreement
		@billing_agreement = BillingAgreement.prefill!(:user_id => user_id)
		#Create a billing agreement with PayPal
		#Setup the request
		@api = PayPal::SDK::Permissions::API.new

	end

	#After billing agreement
	def post_create_billing_agreement

	end
	
private

	def paypal_api_error(e)
		flash[:error] = e.response.details.collect(&:long_message).join('<br />')
		redirect_to(:back)
	end	
end