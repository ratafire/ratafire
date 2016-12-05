class StaticPages::HomeController < ApplicationController
#This controller controls functions related to homepage

	layout 'home'

	#Before filters
	before_filter :load_user, only:[:home]	
	before_filter :show_contacts, only:[:home]
	before_filter :show_followed, only:[:home]
	before_filter :show_liked, only:[:home]	

	def home
		if user_signed_in?
			@followed_user = Array.new(50)
			if @user.likeds.any?
				@user.likeds.order("last_seen desc").page(params[:followed_update]).per_page(50).each do |followed|
					@followed_user.push(followed.id)
				end
			end
			@followed_user.push(@user.id)
			if @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @followed_user, owner_type: "User", :published => true,trackable_type: ["Majorpost"]).page(params[:page]).per_page(5)
				#Mark activity as read
				if user_signed_in? && @user != current_user
					@activities.mark_as_read! :all, :for => current_user
				end
			end
			#Latest updates
			@latest_updates = PublicActivity::Activity.order("created_at desc").where(owner_id: @user, owner_type: "User", :published => true,trackable_type: ["Subscription","LikedUser"]).page(params[:page]).per_page(5)
		end
	end

protected

	def load_user
		if user_signed_in?
			@user = current_user
		end
	end

	def show_contacts
		if user_signed_in?
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
	end

	def show_followed
		if user_signed_in?
			@followed = current_user.likeds.order("last_seen desc").page(params[:followed_update]).per_page(3)
		end
	end

	def show_liked
		if user_signed_in?
			@liked = PublicActivity::Activity.order("created_at desc").tagged_with(@user.id.to_s, :on => :liker, :any => true, :test => false, :deleted => nil).first
		end
	end

end