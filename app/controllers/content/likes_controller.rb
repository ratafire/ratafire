class Content::LikesController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user
	before_filter :show_contacts, only:[:show]
	before_filter :show_followed, only:[:show]
	before_filter :show_liked, only:[:show]

	#REST Methods -----------------------------------

	#user_content_likes GET
	#/users/:user_id/content/likes
	def show
		@popoverclass = SecureRandom.hex(16)
		@activities = PublicActivity::Activity.order("created_at desc").tagged_with(@user.id.to_s, :on => :liker, :any => true, :test => false, :deleted => nil).paginate(page: params[:page], :per_page => 6)
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
		add_score(@user,current_user)
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
					#update liked record
					update_liked_record(current_user.id,@campaign.user.id)
					#achievement
					Resque.enqueue(Achievement::FollowLess, current_user.id, @campaign.user.id)
				end
			end
		end
		#Update activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:campaign_id],'Campaign')
			@activity.liker_list.add(current_user.id)
			@activity.save
		end
		add_score(@user,current_user)
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
						trackable_type: "LikerUser",
						owner_id: current_user.id,
						owner_type: "User",
						key: "liked_user.create",
						)
					#liked record
					update_liked_record(current_user.id,@user.id)
					#achievement
					Resque.enqueue(Achievement::FollowLess, @user.id, current_user.id)
				end
			end
		end
		#add score to user
		add_score(@user,current_user)
		#add streamlab
		if @user.streamlab
			@user.streamlab.post_alert(name:current_user.preferred_name, alert_type:'follow')
		end
	rescue
		#rescue
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
		remove_score(@user, current_user)
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
			#liked record
			deactivate_liked_record(current_user.id,@campaign.user.id)
		end
		#Update activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:campaign_id],'Campaign')
			@activity.liker_list.remove(current_user.id.to_s)
			@activity.save
		end
		remove_score(@user, current_user)
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
				#liked record
				deactivate_liked_record(current_user.id,@user.id)
			end
		end
		remove_score(@user, current_user)
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
				#liked record
				deactivate_liked_record(@user.id, current_user.id)
			end
			redirect_to(:back)
		end
		remove_score(current_user, @user)
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

	def add_score(liked,liker)
		#Add score to liker
		if liker.try(:level) <= 59
			if @level_xp_liker = LevelXp.find(liker.level)
				liker.add_points((@level_xp_liker.get_follower/2).to_i, category: 'liker')
			end
			#Check level
			i = liker.level
			while liker.points >= LevelXp.find(i).total_xp_required
				i += 1
				liker_real_level = i
			end
			if liker_real_level
				if liker_real_level > liker.level
					liker.update(
						level: liker_real_level
					)
                    Notification.create(
                        user_id: liker.id,
                        trackable_id: liker.level,
                        trackable_type: "Level",
                        notification_type: "level_up"
                    )
                    @levelup_liker = true
                    #Check level up achievement
                    Resque.enqueue(Achievement::Level, liker.id)
				end
			end
		end
		#Add score to liked
		if liked.try(:level) <= 59
			if @level_xp_liked = LevelXp.find(liked.level)
				liked.add_points(@level_xp_liked.get_follower, category: 'liked')
			end
			#Check level
			i = liked.level
			while liked.points >= LevelXp.find(i).total_xp_required
				i += 1
				liked_real_level = i
			end
			if liked_real_level
				if liked_real_level > liked.level 
					liked.update(
						level: liked_real_level
					)
                    Notification.create(
                        user_id: liked.id,
                        trackable_id: liked.level,
                        trackable_type: "Level",
                        notification_type: "level_up"
                    )
                    #Check level up achievement
                    Resque.enqueue(Achievement::Level, liked.id)
				end
			end
		end
	end

	def remove_score(liked, liker)
		#Remove score from liker
		if liker.level <= 60
			if @level_xp_liker = LevelXp.find(liker.level)
				liked.add_points(-(@level_xp_liker.get_follower/2).to_i, category: 'liker')
			end
			#Check level 
			i = liker.level
			unless i == 1
				while liker.points < LevelXp.find(i-1).total_xp_required
					i -= 1
					liker_real_level = i
					if i == 1
						break
					end
				end
			end
			if liker_real_level
				if liker_real_level < liker.level
					#level down user
					liker.update(
						level: liker_real_level
					)
					#Delete notifications
                    Notification.where(user_id: liker.id, notification_type: "level_up").each do |notification|
                        if notification.trackable_id > liker_real_level
                            notification.destroy
                        end
                    end
				end
			end
		end
		#Remove score from liked
		if liked.level <= 60
			if @level_xp_liked = LevelXp.find(liked.level)
				liked.add_points(-(@level_xp_liked.get_follower/2).to_i, category: 'liker')
			end
			#Check level 
			i = liked.level
			unless i == 1
				while liked.points < LevelXp.find(i-1).total_xp_required
					i -= 1
					liked_real_level = i
					if i == 1
						break
					end
				end
			end
			if liked_real_level
				if liked_real_level < liked.level
					#level down user
					liked.update(
						level: liked_real_level
					)
					#Delete notifications
                    Notification.where(user_id: liked.id, notification_type: "level_up").each do |notification|
                        if notification.trackable_id > liked_real_level
                            notification.destroy
                        end
                    end
				end
			end
		end
	end

	def update_liked_record(liker_id, liked_id)
		if @liked_record = LikedRecord.find_by_liker_id_and_liked_id(liker_id, liked_id)
			@liked_record.update(
				counter: @liked_record.counter+1,
				active: true
			)
		else
			@liked_record = LikedRecord.create(
				liker_id: liker_id,
				liked_id: liked_id,
				active: true,
				counter: 1
			)
		end
	end

	def deactivate_liked_record(liker_id,liked_id)
		if @liked_record = LikedRecord.find_by_liker_id_and_liked_id(liker_id,liked_id)
			@liked_record.update(
				active: false
			)
		end
	end

end