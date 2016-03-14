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
			@friends = @user.friends.order('created_at asc').page(params[:friend]).per_page(3)
		end
	end

	#backers_user_profile_tabs GET
	#Backers tab
	#/users/:user_id/profile/tabs/backers
	def backers
	end

	#backed_user_profile_tabs GET
	#Backed tab
	#/users/:user_id/profile/tabs/backed
	def backed
	end

	#subscribed_user_profile_tabs GET
	#Subscribed tab
	#/users/:user_id/profile/tabs/subscribed
	def subscribed
	end

protected

	def load_user
		@user = User.find_by_username(params[:user_id])
	end

end