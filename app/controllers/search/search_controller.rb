class Search::SearchController < ApplicationController

	layout 'profile'

	#before filter
	before_filter :load_user, only:[:search]
	protect_from_forgery :except => [:search]

	#REST Methods -----------------------------------

	#NoREST Methods -----------------------------------

	# search GET
	# search_ratafire/s/search
	def search
		@search = Elasticsearch::Model.search(params[:q], [Majorpost, Campaign, User]).page(params[:page]).per_page(10).records.where(deleted_at: nil)
		if user_signed_in?
			show_contacts
			show_followed
			show_liked
		end
		@site_activity = PublicActivity::Activity.order("created_at desc").where(owner_type: "User", :published => true,:abandoned => nil,trackable_type: ["Subscription","LikedUser"]).page(params[:page]).per_page(5)
	end

protected

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