class Explore::ExploreController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user, except: [:surprise_me]
	before_filter :show_contacts, only:[:back_creators]
	before_filter :show_followed, only:[:back_creators]
	before_filter :show_liked, only:[:back_creators]
	# explore_explore_surprise_me GET 
	# /explore/explore/:explore_id/surprise_me
	def surprise_me
		redirect_to profile_url_path(User.all.sample(1).first.username)
	end

	# explore_explore_back_creators GET
	# explore/back_creators/:category_id/:sub_category_id
	def back_creators
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_type: "User", :published => true,trackable_type: ["Campaign"]).page(params[:page]).per_page(1)
		#if params[:category_id] == "default"
		#	if params[:sub_category_id] == "default"
		#		@activities = PublicActivity::Activity.order("created_at desc").where(owner_type: "User", :published => true,trackable_type: ["Campaign"]).page(params[:page]).per_page(1)
		#	else
		#		@activities = PublicActivity::Activity.order("created_at desc").where(owner_type: "User", :published => true,trackable_type: ["Campaign"], sub_category: params[:sub_category_id]).page(params[:page]).per_page(1)
		#	end
		#else
		#	if params[:sub_category_id] == "default"
		#		@activities = PublicActivity::Activity.order("created_at desc").where(owner_type: "User", :published => true,trackable_type: ["Campaign"], category: params[:category_id]).page(params[:page]).per_page(1)
		#	else
		#		@activities = PublicActivity::Activity.order("created_at desc").where(owner_type: "User", :published => true,trackable_type: ["Campaign"], category: params[:category_id], sub_category: params[:sub_category_id]).page(params[:page]).per_page(1)
		#	end
		#end
		@popoverclass = SecureRandom.hex(16)
		@showcategory = true
	end

private
	
	def load_user
		if user_signed_in?
			@user = current_user
		end
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

	def show_liked
		@liked = PublicActivity::Activity.order("created_at desc").tagged_with(@user.id.to_s, :on => :liker, :any => true, :test => false, :deleted => nil).first
	end	

end