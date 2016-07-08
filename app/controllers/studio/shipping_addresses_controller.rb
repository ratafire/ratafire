class Studio::ShippingAddressesController < ApplicationController

	layout 'studio'

	#Before filters
	before_filter :load_user

	#REST Methods -----------------------------------

	# user_studio_shipping_addresses POST
	# /users/:user_id/studio/shipping_addresses
	def create
		@shipping_address = ShippingAddress.new(shipping_address_params)
		@shipping_address.user_id = @user.id
		check_us_postal_code_and_create_shipping_address
	end

	# update_user_studio_shipping_addresses PATCH
	# /users/:user_id/studio/shipping_addresses/:shipping_address_id
	def update
		if @shipping_address = ShippingAddress.find(params[:shipping_address_id])
			@shipping_address.attributes = shipping_address_params
			check_us_postal_code_and_create_shipping_address
			@shipping_addresses = @user.shipping_addresses.page(params[:page]).per_page(5)
		else
			redirect_to(:back)
			flash[:error] = t('errors.messages.not_saved')
		end
	end

	# destroy_user_studio_shipping_addresses DELETE
	# /users/:user_id/studio/shipping_addresses/:shipping_address_id
	def destroy
		@shipping_address = ShippingAddress.find(params[:shipping_address_id])
		@shipping_address.destroy
		@shipping_addresses = @user.shipping_addresses.page(params[:page]).per_page(5)
		@shipping_address = ShippingAddress.new()
	end

	#NoREST Methods -----------------------------------

	# my_mailing_address_user_studio_shipping_addresses GET
	# /users/:user_id/studio/shipping_addresses/my_mailing_address
	def my_mailing_address
		if @user.shipping_addresses.count == 0
			@shipping_address = ShippingAddress.new()
		else
			@shipping_addresses = @user.shipping_addresses.page(params[:page]).per_page(5)
		end
	end

	# edit_user_studio_shipping_addresses GET
	# /users/:user_id/studio/shipping_addresses/edit
	def edit
		@shipping_address = ShippingAddress.find(params[:shipping_address_id])
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

	def shipping_address_params
		params.require(:shipping_address).permit(:country, :city, :line1, :name, :postal_code)
	end

	def check_us_postal_code_and_create_shipping_address
		if @shipping_address.country == "US"
			if @zipcodes = ZipCodes.identify(@shipping_address.postal_code)
				@shipping_address.state = @zipcodes[:state_code]
				update_shipping_address
			else
				flash[:error] = t('errors.messages.postal_code')
				redirect_to(:back)
			end
		else
			update_shipping_address
		end
	end

	def update_shipping_address
		if @shipping_address.save
		else
			flash[:error] = @shipping_address.errors.full_messages
			redirect_to(:back)
		end
	end

end