class Payment::BacksController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user
	before_filter :not_current_user, only:[:new, :payment]
	before_filter :show_contacts, only:[:new]
	before_filter :show_followed, only:[:new, :payment]

	#REST Methods -----------------------------------

	# new_user_payment_backs GET
	# /users/:user_id/payment/backs/new
	def new
		@subscription = Subscription.new(subscription_params)
		if @user.active_reward.shipping == "some"
			@countires = Array.new
			@user.active_reward.shippings.each do |shipping|
				@countires.push shipping.country
			end
		end
	end

	# user_payment_backs POST
	# /users/:user_id/payment/backs
	def create
	end

	# user_payment_backs GET
	#/users/:user_id/payment/backs
	def show
	end

	#noREST Methods -----------------------------------

	# country_user_payment_backs GET
	# /users/:user_id/payment/backs/country/:country_id
	def country
		@shipping_fee = @user.active_reward.shippings.where(:country => params[:country_id]).first.amount
	end

	# payment_user_payment_backs GET
	# /users/:user_id/payment/backs/payment
	def payment
		@subscription = Subscription.new(subscription_params)
		@card = @subscription.cards.new()
		@shipping_address = @subscription.shipping_addresses.new()
		if @user.active_reward.shipping == "some"
			@countires = Array.new
			@user.active_reward.shippings.each do |shipping|
				@countires.push shipping.country
			end
		end
	end

protected

	def load_user
		@user = User.find_by_uid(params[:user_id])
	end

	def show_contacts
		@popoverclass = SecureRandom.hex(16)
		if @user.friends.count > 0
			if @friends = @user.friends.order('last_seen desc')
				@contacts = @friends
			end
		end
		if @user.record_subscribers.count > 0
			if @backers = @user.record_subscribers.order('last_seen desc')
				if @contacts
					@contacts += @backers
				else
					@contacts = @backers
				end
			end
		end
		if @user.record_subscribed.count > 0
			if @backeds = @user.record_subscribed.order('last_seen desc')
				if @contacts
					@contacts += @backeds
				else
					@contacts = @backeds
				end
			end
		end
		if @contacts
			@contacts = @contacts.sort_by(&:created_at).reverse.uniq.paginate(:per_page => 9)
		end
	end	

	def show_followed
		if user_signed_in?
			@followed = current_user.likeds.order("last_seen desc").page(params[:followed_update]).per_page(3)
		end
	end

	def subscription_params
		params.permit(:amount, :shipping_country, :funding_type, :get_reward)
	end

	def not_current_user
		if user_signed_in?
			if current_user == @user
				flash[:alert] = t('errors.messages.back_yourself') + t('errors.messages.arrow_to_the_knee')
				redirect_to(:back)
			end
		end
	end

end