class Studio::ShippingsController < ApplicationController
	#Before filters
	before_filter :load_shipping
	before_filter :load_reward
	#NoREST Methods -----------------------------------
	#studio_shipping_create_shipping POST
	#/studio/shippings/:shipping_id/shipping/:user_id/:campaign_id/:reward_id/:amount/:country
	def create_shipping
		Shipping.create(
			user_id: params[:user_id],
			campaign_id: params[:campaign_id],
			reward_id: params[:reward_id],
			amount: params[:amount],
			country: params[:country]
		)
	end

	def update_shipping
	end

	#studio_shipping_create_shipping_anywhere POST
	#/studio/shippings/:shipping_id/shipping_anywhere/:user_id/:campaign_id/:reward_id/:amount
	def create_shipping_anywhere
		ShippingAnywhere.create(
			user_id: params[:user_id],
			campaign_id: params[:campaign_id],
			reward_id: params[:reward_id],
			amount: params[:amount]
		)
	end

	def update_shipping_anywhere
	end

	#studio_shipping_delete_shipping DELETE
	#/studio/shippings/:shipping_id/shipping/:shipping_id
	def delete_shipping
		@shipping.destroy
	end

	#studio_shipping_delete_shipping_anywhere DELETE
	#/studio/shippings/:shipping_id/shipping_anywhere/:shipping_anywhere_id
	def delete_shipping_anywhere
		@shipping_anywhere.destroy
	end

private

	def load_shipping
		#load shipping if there is a shipping
		if params[:shipping_id]
			@shipping = Shipping.find(params[:shipping_id])
		end
		#load shipping anywhere if there is a shipping anywhere
		if params[:shipping_anywhere]
			@shipping_anywhere = ShippingAnywhere.find(params[:shipping_anywhere_id])
		end
	end

	def load_reward
		if params[:reward_id]
			@reward = Reward.find(params[:reward_id])
		end
	end

end