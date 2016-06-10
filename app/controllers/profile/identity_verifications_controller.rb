class Profile::IdentityVerificationsController < ApplicationController

	extend AttrEncrypted
	require "stripe"

	#Before filters
	before_filter :load_user

	#REST Methods -----------------------------------

	#user_profile_identity_verifications POST     
	#/users/:user_id/profile/identity_verifications(.:format)
	def create
		if @user.identity_verification
			@identity_verification = @user.identity_verification.write_attribute(identity_verification_params)
		else
			@identity_verification = IdentityVerification.new(identity_verification_params)
		end
		if @identity_verification.country == 'US'
			@ssn = Identified::SSN.new(@identity_verification.ssn.gsub(/(\d{3})(\d{2})(\d{3})/, '\1-\2-\3'))
			if @ssn.valid?
				process_identity_verification
			else
				redirect_to(:back)
			end
		else
			process_identity_verification
		end
	end

protected

	def process_identity_verification
		begin
			#Create Stripe Account if Stripe Account is not created
			connect_to_stripe
			if @user.stripe_account
				#Update a Stripe account
				if @stripe_account = Stripe::Account.retrieve(@user.stripe_account.stripe_id)
					@stripe_account.legal_entity.type = 'individual'
					@stripe_account.legal_entity.dob.day = @identity_verification.birthday.split('-')[2]
					@stripe_account.legal_entity.dob.month = @identity_verification.birthday.split('-')[1]
					@stripe_account.legal_entity.dob.year = @identity_verification.birthday.split('-')[0]
					@stripe_account.legal_entity.first_name = @identity_verification.first_name
					@stripe_account.legal_entity.last_name = @identity_verification.last_name
					@stripe_account.save
				end
				#Update User Stripe Account on the Server
				@user_stripe_account = StripeAccount.stripe_account_update(@stripe_account, @user.id) 
			else
				#Create a Stripe account
				@stripe_account = Stripe::Account.create(
	  				:managed => true,
	  				:country => @identity_verification.country,
	  				:legal_entity => {
	  					:type => 'individual',
	  					:dob => {
	  						:day => @identity_verification.birthday.split('-')[2],
	  						:month => @identity_verification.birthday.split('-')[1],
	  						:year => @identity_verification.birthday.split('-')[0]
	  					},
	  					:first_name => @identity_verification.first_name,
	  					:last_name => @identity_verification.last_name,
	  				},
	  				:tos_acceptance => {
	  					:date => Time.now.to_time.to_i,
	  					:ip => request.remote_ip
	  				}
				)
				#Create user stripe account
				@user_stripe_account = StripeAccount.stripe_account_create(@stripe_account, @user.id)
			end
			#Get into pending
			if @identity_verification.country == 'US'
				@identity_verification.update(
					user_id: @user.id,
					ssn_last4: @identity_verification.ssn.to_s.split(//).last(4).join("").to_s,
					status: 'Approved'
				) 
				#Update SSN on stripe server
				@stripe = Stripe::Account.retrieve(@user_stripe_account.stripe_id)
				@stripe.legal_entity.ssn_last_4 = @identity_verification.ssn.to_s.split(//).last(4).join("").to_s
				@stripe.save
			else
				if @identity_verification.verification_type == 'passport'
					@identity_verification.passport_last4 = @identity_verification.passport.split(//).last(4).to_s
					#Update Passport on stripe server
					
					@stripe.legal_entity.personal_id_number = @identity_verification.passport
					@stripe.save
				else
					@identity_verification.passport_last4 = @identity_verification.id_card.split(//).last(4).to_s
					#Update ID card on stripe server
					@stripe = Stripe::Account.retrieve(@user_stripe_account.stripe_id)
					@stripe.legal_entity.personal_id_number = @identity_verification.id_card
					@stripe.save
				end
				@identity_verification.update(
					user_id: @user.id,
					status: 'Pending'
				)
				#Upload document file to stripe
				@stripe_file = Stripe::FileUpload.create(
				  {
				    :purpose => 'identity_document',
				    :file => open(@identity_verification.identity_document.url(:preview1280))
				  },
				  {:stripe_account => @user.stripe_account.stripe_id}
				)
				@stripe.legal_entity.verification.document = @stripe_file.id
				@stripe.save
			end
			if @user.campaigns.count > 0 
				redirect_to apply_user_studio_campaigns_path(@user.username, @user.campaigns.first)
			else
				redirect_to(:back)
			end
		rescue
			redirect_to(:back)
			#Delete identity verification
			if @identity_verification
				@identity_verification.destroy
			end
		end
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

	def identity_verification_params
		params.require(:identity_verification).permit(:user_id,:uuid, :ssn, :encrypted_ssn, :passport, :encrypted_passport, :drivers_license, :encrypted_drivers_licence, :id_card, :encrypted_id_card, :birthday, :country, :first_name, :last_name, :identity_document, :verification_type)
	end

end