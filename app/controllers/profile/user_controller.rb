class Profile::UserController < ApplicationController
#This controller controls functions related to homepage

	layout 'profile'
	require 'rqrcode'

	#Before filters
	before_filter :load_user, only:[:profile]

	protect_from_forgery :except => [:update_profile]

	def profile
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @user, owner_type: "User", :published => true,trackable_type: ["Majorpost"]).page(params[:page]).per_page(5)
		@popoverclass = SecureRandom.hex(16)
		if @user.friends.count > 0
			@friends = @user.friends.order('created_at asc')
		end
		if @user.record_subscribers.count > 0
			@backers = @user.record_subscribers.order('created_at asc')
		end
		if @user.record_subscribed.count > 0
			@backeds = @user.record_subscribed.order('created_at asc')
		end
		@contacts = (@friends + @backers + @backeds).sort_by(&:created_at).reverse.uniq.paginate(:per_page => 9)
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:username])
	end	

	def user_params
		params.require(:user).permit(:profilephoto)
	end		

end