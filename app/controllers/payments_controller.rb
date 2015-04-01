class PaymentsController < ApplicationController
	#rescue_from Paypal::Exception::APIError, with: :paypal_api_error
	#require 'paypal-sdk-permissions'
	before_filter :create_request, only: [:create_billing_agreement, :billing_agreement_success, :remove_billing_agreement]

	#Create Billing Agreement with Paypal
	def create_billing_agreement
		#Setup the request
		payment_request = Paypal::Payment::Request.new(
  			:billing_type  => "MerchantInitiatedBilling",
  			# Or ":billing_type => :MerchantInitiatedBillingSingleAgreement"
  			# Read official document for details
  			:billing_agreement_description => "Pay Ratafire with PayPal"
		)
		if Rails.env.development? then
			response = @request.setup(
  				payment_request,
  				"http://localhost:3000/paypal_agreement_success",
  				"http://localhost:3000/paypal_agreement_cancel"
			)
		else
			response = @request.setup(
  				payment_request,
  				"https://www.ratafire.com/paypal_agreement_success",
  				"https://www.ratafire.com/paypal_agreement_cancel"
			)			
		end
		redirect_to response.redirect_uri
	end

	#Get Info from agreement with PayPal success
	def billing_agreement_success
		response = @request.agree! params[:token]
		if current_user != nil then
			#Find the user
			@user = User.find(current_user.id)
			#Destry existed paypal billing agreement
			if @user.billing_agreement != nil then
				@request.revoke! @billing_agreement.billing_agreement_id
				@user.billing_agreement.deleted = true
				@user.billing_agreement.save
			end
			#Create a new billing agreement
			@billing_agreement = BillingAgreement.prefill!(:user_id => @user.id, :billing_agreement_id => response.billing_agreement.identifier)
			redirect_to payment_settings_path(@user.id)
		else
			redirect_to root_path
		end
	end

	#Get Info from agreement with PayPal failed
	def billing_agreement_cancel
		if current_user != nil then
			redirect_to payment_settings_path(current_user.id)
		else
			redirect_to root_path
		end
	end

	#Remove a billing agreement
	def remove_billing_agreement
		@billing_agreement = BillingAgreement.find(params[:id])
		if @billing_agreement != nil then
			@request.revoke! @billing_agreement.billing_agreement_id
			@billing_agreement.deleted = true
			@billing_agreement.save
			redirect_to(:back)
		else
			redirect_to(:back)
		end
	rescue Paypal::Exception::APIError
		flash[:error] = "PayPal not valid."
		@billing_agreement.deleted = true
		@billing_agreement.save
		redirect_to(:back)
	end
	
private

	def paypal_api_error(e)
		flash[:error] = e.response.details.collect(&:long_message).join('<br />')
		redirect_to(:back)
	end	

	def create_request
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
	end
end