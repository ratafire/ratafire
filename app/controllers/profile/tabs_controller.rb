class Profile::TabsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user
	before_filter :show_contacts, only:[:friends, :gallery, :videos]
	before_filter :show_followed, only:[:friends, :gallery, :videos]
	before_filter :show_liked, only:[:friends, :gallery, :videos]

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
	end

	#gallery_user_profile_tabs GET
	#Gallery tab
	#/users/:user_id/profile/tabs/gallery
	def gallery
		@artworks = @user.artwork.paginate(:page => params[:page], :per_page => 9)
	end

	def videos
		@videos = @user.video.where(:deleted => nil).paginate(:page => params[:page], :per_page => 9)
	end

protected

	def load_user
		unless @user = User.find(params[:user_id])
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