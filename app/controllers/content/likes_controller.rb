class Content::LikesController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user, only:[:show]
	before_filter :show_contacts, only:[:show]
	before_filter :show_followed, only:[:show]
	before_filter :show_liked, only:[:show]

	#REST Methods -----------------------------------

	#user_content_likes GET
	#/users/:user_id/content/likes
	def show
		@popoverclass = SecureRandom.hex(16)
		@activities = PublicActivity::Activity.order("created_at desc").tagged_with(@user.id.to_s, :on => :liker, :any => true, :test => false, :deleted => nil).paginate(page: params[:page], :per_page => 5)
	end

	#NoREST Methods -----------------------------------

	#majorpost_user_content_likes GET
	#/users/:user_id/content/likes/majorpost/:majorpost_id
	def majorpost
		#Create like
		@like = LikedMajorpost.create(
			user_id: current_user.id,
			majorpost_id: params[:majorpost_id]
		)
		#Update activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:majorpost_id],'Majorpost')
			@activity.liker_list.add(current_user.id)
			@activity.save
		end
	end

	#campaign_user_content_likes GET
	#/users/:user_id/content/likes/campaign/:campaign_id
	def campaign
		#Create like in Campaign
		@like = LikedCampaign.create(
			user_id: current_user.id,
			campaign_id: params[:campaign_id]
		)
		#Create like in user
		if @campaign = Campaign.find(params[:campaign_id])
			if current_user.id != @campaign.user.id
				unless @liked_user = LikedUser.find_by_liked_id_and_liker_id(@campaign.user.id, current_user.id)
					@liked_user = LikedUser.create(
						liker_id: current_user.id,
						liked_id: @campaign.user.id
					)
					#if friends make them friends
					if @reverse_liked_user = LikedUser.find_by_liked_id_and_liker_id(current_user.id, @campaign.user.id)
						@friendship = Friendship.where(user_id: current_user.id, friend_id: @campaign.user.id).first_or_create(
							user_id: current_user.id,
							friend_id: @campaign.user.id,
							friendship_init: current_user.id
						)
						@reverse_friendship = Friendship.where(user_id: @campaign.user.id, friend_id: current_user.id).first_or_create(
							user_id: @campaign.user.id,
							friend_id: current_user.id,
							friendship_init: @campaign.user.id
						)
					end
				end
			end
		end
		#Update activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:campaign_id],'Campaign')
			@activity.liker_list.add(current_user.id)
			@activity.save
		end
	end

	#user_user_content_likes GET
	#/users/:user_id/content/likes/user/:user_id
	def user
		if @user = User.find(params[:user_id])
			if current_user != @user
				unless @liked_user = LikedUser.find_by_liked_id_and_liker_id(@user.id, current_user.id)
					@liked_user = LikedUser.create(
						liker_id: current_user.id,
						liked_id: @user.id
					)
					#if friends make them friends
					if @reverse_liked_user = LikedUser.find_by_liked_id_and_liker_id(current_user.id, @user.id)
						@friendship = Friendship.where(user_id: current_user.id, friend_id: @user.id).first_or_create(
							user_id: current_user.id,
							friend_id: @user.id,
							friendship_init: current_user.id
						)
						@reverse_friendship = Friendship.where(user_id: @user.id, friend_id: current_user.id).first_or_create(
							user_id: @user.id,
							friend_id: current_user.id,
							friendship_init: @user.id
						)
					end
					#Create activity
					@activity = PublicActivity::Activity.create(
						trackable_id: @liked_user.id,
						trackable_type: "LikedUser",
						owner_id: @user.id,
						owner_type: "User",
						key: "liked_user.create",
						)
					@activity = PublicActivity::Activity.create(
						trackable_id: @liked_user.id,
						trackable_type: "LikedUser",
						owner_id: current_user.id,
						owner_type: "User",
						key: "liked_user.create",
						)
				end
			end
		end
	end

	#majorpost_user_content_likes DELETE
	#/users/:user_id/content/likes/majorpost/:majorpost_id
	def unlike_majorpost
		if @unlike = LikedMajorpost.find_by_user_id_and_majorpost_id(current_user.id,params[:majorpost_id])
			@majorpost = @unlike.majorpost
			#Activity of like
			if @like_activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@unlike.id,'LikedMajorpost')
				@like_activity.update(
					deleted: true,
					deleted_at: Time.now
				)
			end
			@unlike.destroy
		end
		#Update activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:majorpost_id],'Majorpost')
			@activity.liker_list.remove(current_user.id.to_s)
			@activity.save
		end
	end

	#campaign_user_content_likes DELETE
	#/users/:user_id/content/likes/campaign/:campaign_id
	def unlike_campaign
		if @unlike = LikedCampaign.find_by_user_id_and_campaign_id(current_user.id,params[:campaign_id])
			@campaign = @unlike.campaign
			#Activity of like Campaign
			if @like_activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@unlike.id,'LikedCampaign')
				@like_activity.update(
					deleted: true,
					deleted_at: Time.now
				)
			end
			@unlike.destroy
		end
		#Unlike user as well
		if @liked_user = LikedUser.find_by_liked_id_and_liker_id(@campaign.user.id, current_user.id)
			#Activity of like user
			if @liked_user_activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@liked_user.id,'LikedUser')
				@liked_user_activity.update(
					deleted: true,
					deleted_at: Time.now
				)
			end
			@liked_user.destroy
			#Remove friendship
			if @friendship = Friendship.find_by_user_id_and_friend_id(current_user.id, @campaign.user.id)
				@friendship.destroy
			end
			if @reverse_friendship = Friendship.find_by_user_id_and_friend_id(@campaign.user.id, current_user.id)
				@reverse_friendship.destroy
			end
		end
		#Update activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:campaign_id],'Campaign')
			@activity.liker_list.remove(current_user.id.to_s)
			@activity.save
		end
	end

	#user_user_content_likes DELETE
	#/users/:user_id/content/likes/campaign/:user_id
	def unlike_user
		#Unlike user as well
		if @user = User.find(params[:user_id])
			if @liked_user = LikedUser.find_by_liked_id_and_liker_id(@user.id, current_user.id)
				@liked = @liked_user.liked
				#Activity of like user
				if @liked_user_activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@liked_user.id,'LikedUser')
					@liked_user_activity.update(
						deleted: true,
						deleted_at: Time.now
					)
				end
				@liked_user.destroy
				#Remove friendship
				if @friendship = Friendship.find_by_user_id_and_friend_id(current_user.id, @user.id)
					@friendship.destroy
				end
				if @reverse_friendship = Friendship.find_by_user_id_and_friend_id(@user.id, current_user.id)
					@reverse_friendship.destroy
				end
			end
		end
	end

	#remove_liker_user_content_likes DELETE
	def remove_liker
		if @user = User.find(params[:user_id])
			if @liked_user = LikedUser.find_by_liked_id_and_liker_id(current_user.id,@user.id)
				@liked = @liked_user.liked
				#Activity of like user
				if @liked_user_activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@liked_user.id,'LikedUser')
					@liked_user_activity.update(
						deleted: true,
						deleted_at: Time.now
					)
				end
				@liked_user.destroy
				#Remove friendship
				if @friendship = Friendship.find_by_user_id_and_friend_id(current_user.id, @user.id)
					@friendship.destroy
				end
				if @reverse_friendship = Friendship.find_by_user_id_and_friend_id(@user.id, current_user.id)
					@reverse_friendship.destroy
				end
			end
			redirect_to(:back)
		end
	end

	#followed_pagination_user_content_likes GET
	#/users/:user_id/content/likes/followed_pagination
	def followed_pagination
		@followed = current_user.likeds.order("last_seen desc").page(params[:followed_update]).per_page(25)
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
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