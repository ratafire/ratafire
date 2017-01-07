class Profile::UserController < ApplicationController
#This controller controls functions related to homepage

	layout 'profile'
	require 'rqrcode'

	#Before filters
	before_filter :load_user, only:[:profile]
	before_filter :show_contacts, only:[:profile]
	before_filter :show_followed, only:[:profile]
	before_filter :show_liked, only:[:profile]
	before_filter :profile_meta, only:[:profile]

	protect_from_forgery :except => [:update_profile]

	def profile
		if @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @user, owner_type: "User", :published => true,trackable_type: ["Majorpost"]).page(params[:page]).per_page(5)
			#Mark activity as read
			if user_signed_in? && @user != current_user
				@activities.mark_as_read! :all, :for => current_user
			end
		end
		#Latest updates
		@latest_updates = Notification.order("created_at desc").where(notification_type:["subscribed_one_time","subscribed_recurring"], deleted: nil).page(params[:page]).per_page(3)
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:username])
	end	

	def profile_meta
		if @user.active_campaign
			#Normal meta tag
			set_meta_tags title: I18n.t('ratafire') + ' - ' + @user.active_campaign.title + ' - ' + @user.preferred_name,
						  description: @user.active_campaign.description,
						  image_src: @user.active_campaign.image.url(:thumbnail800),
						  author: @user.preferred_name
			#Open Graph Object
			set_meta_tags og: {
				title:    I18n.t('ratafire') + ' - ' + @user.active_campaign.title + ' - ' + @user.preferred_name,
				type:     'website',
				image:    @user.active_campaign.image.url(:thumbnail800),
				author: @user.preferred_name
			}
			#Twitter Card
			set_meta_tags twitter: {
				card:  "summary_large_image",
				site: "ratafire.com",
				creator: @user.preferred_name,
				title: @user.active_campaign.title,
				description: @user.active_campaign.description,
				image: @user.active_campaign.image.url(:thumbnail800),
				author: @user.preferred_name
			}
		else
			if @user.bio
				#Normal meta tag
				set_meta_tags title: I18n.t('ratafire') + ' - ' + @user.preferred_name,
							  description: @user.bio,
							  image_src: @user.profilephoto.image.url(:original),
							  author: @user.preferred_name
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary",
					site: "ratafire.com",
					title: I18n.t('ratafire') + ' - ' + @user.preferred_name,
					description: @user.bio,
					image: @user.profilephoto.image.url(:thumbnail256),
					author: @user.preferred_name
				}
			else
				#Normal meta tag
				set_meta_tags title: I18n.t('ratafire') + ' - ' + @user.preferred_name,
				              description: @user.tagline,
				              image_src: @user.profilephoto.image.url(:original),
				              author: @user.preferred_name
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary",
					site: "ratafire.com",
					title: I18n.t('ratafire') + ' - ' + @user.preferred_name,
					description: @user.tagline,
					image: @user.profilephoto.image.url(:thumbnail256),
					author: @user.preferred_name
				}
			end
		end
	end

	def user_params
		params.require(:user).permit(:profilephoto)
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