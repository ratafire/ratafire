class Profile::TabsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user

	#NoREST Methods -----------------------------------
	
	#updates_user_profile_tabs GET
	#Update tab
	#/users/:user_id/profile/tabs/updates
	def updates
	end

	#friends_user_profile_tabs GET
	#Friends tab
	#/users/:user_id/profile/tabs/friends
	def friends
		if @user.friends.count > 0
			@friends = @user.friends.order('created_at asc')
		end
		if @user.record_subscribers.count > 0
			@backers = @user.record_subscribers.order('created_at asc')
		end
		if @user.record_subscribed.count > 0
			@backeds = @user.record_subscribed.order('created_at asc')
		end
		@popoverclass = SecureRandom.hex(16)
		@contacts = (@friends + @backers + @backeds).sort_by(&:created_at).reverse.uniq.paginate(:page => params[:page], :per_page => 9)
	end

protected

	def load_user
		unless @user = User.find(params[:user_id])
		end
	end

end