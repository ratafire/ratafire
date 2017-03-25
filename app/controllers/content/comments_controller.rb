class Content::CommentsController < ApplicationController

	layout 'profile'

	before_filter :load_comment, except: [:create]

	#REST Methods -----------------------------------

	#content_comments POST
	#/content/comments
	def create
		@comment = Comment.new(comment_params)
		@majorpost = Majorpost.find(params[:comment][:majorpost_id])
		#Detect language
		if language = CLD.detect_language(@comment.content)
			@comment.locale = language[:code]
		end		
		if @comment.update(
			user_id: current_user.id, 
			campaign_id: @majorpost.campaign_id,
			majorpost_user_id: @majorpost.user_id,
			excerpt: ActionView::Base.full_sanitizer.sanitize(@comment.content).squish.truncate(140)
		)
			@majorpost = Majorpost.find(@comment.majorpost_id)
			#Update activity
			if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@comment.id,'Comment')
				@activity.update_columns(majorpost_id: @comment.majorpost_id)
			end
			#Create notification
			unless @comment.user == @majorpost.user
				if @comment.main_comment
					Notification.create(
						user_id: @comment.main_comment.user_id,
						trackable_id: @comment.id,
						trackable_type: "Comment",
						notification_type: "reply_create"
					)
					unless @majorpost.user_id == @comment.main_comment.user_id
						Notification.create(
							user_id: @majorpost.user_id,
							trackable_id: @comment.id,
							trackable_type: "Comment",
							notification_type: "comment_create"
						)
					end
				else
					Notification.create(
						user_id: @majorpost.user_id,
						trackable_id: @comment.id,
						trackable_type: "Comment",
						notification_type: "comment_create"
					)
				end
			end
		end
		@new_comment = Comment.new
		#Create a popover random class for js unique refresh
		@popoverclass = SecureRandom.hex(16)		
		#Add score
		add_score(@comment.majorpost.user, @comment.user)		
	end

	#content_comment DELETE
	#/content/comments/:id
	def destroy
		#Set the comment as deleted
		@comment.update(
			deleted: true,
			deleted_at: Time.now
		)
		#Delete majorpost activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@comment.id,'Comment')
			@activity.update(
				deleted: true,
				deleted_at: @comment.deleted_at
				)
		end
		#Remove score
		remove_score(@comment.majorpost.user, @comment.user)
		#Remove notification
		if @comment_notifications = Notification.where(trackable_id: @comment.id)
			@comment_notifications.each do |comment_notification|
				comment_notification.destroy
			end
		end
	end

private

	def update_comment_activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@comment.id,'Comment')
			@activity.update(
				majorpost_id: @comment.majorpost_id
			)
		end
	end

	def load_user
		@user = current_user
	end

	def load_comment
		unless @comment = Comment.find_by_uuid(params[:id])
			unless @comment = Comment.find_by_uuid(params[:comment_id])
			end
		end
	end	

	def comment_params
		params.require(:comment).permit(:user_id,:majorpost_id, :content,:project_id, :reply_id)
	end

	def add_score(commented,commenter)
		#Add score to commenter
		if commenter.try(:level) <= 59
			if @level_xp_commenter = LevelXp.find(commenter.level)
				commenter.add_points((@level_xp_commenter.get_follower).to_i, category: 'commenter')
			end
			#Check level
			i = commenter.level
			while commenter.points >= LevelXp.find(i).total_xp_required
				i += 1
				commenter_real_level = i
			end
			if commenter_real_level
				if commenter_real_level > commenter.level
					commenter.update(
						level: commenter_real_level
					)
                    Notification.create(
                        user_id: commenter.id,
                        trackable_id: commenter.level,
                        trackable_type: "Level",
                        notification_type: "level_up"
                    )
                    @levelup_commenter = true
                    #Check level up achievement
                    Resque.enqueue(Achievement::Level, commenter.id)
				end
			end
		end
		#Add score to commented
		if commented.try(:level) <= 59
			if @level_xp_commented = LevelXp.find(commented.level)
				commented.add_points(@level_xp_commented.get_follower*2, category: 'commented')
			end
			#Check level
			i = commented.level
			while commented.points >= LevelXp.find(i).total_xp_required
				i += 1
				commented_real_level = i
			end
			if commented_real_level
				if commented_real_level > commented.level 
					commented.update(
						level: commented_real_level
					)
                    Notification.create(
                        user_id: commented.id,
                        trackable_id: commented.level,
                        trackable_type: "Level",
                        notification_type: "level_up"
                    )
                    #Check level up achievement
                    Resque.enqueue(Achievement::Level, commented.id)
				end
			end
		end
	end	

	def remove_score(commented, liker)
		#Remove score from liker
		if liker.level <= 60
			if @level_xp_liker = LevelXp.find(liker.level)
				commented.add_points(-(@level_xp_liker.get_follower/2).to_i, category: 'liker')
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
		#Remove score from commented
		if commented.level <= 60
			if @level_xp_commented = LevelXp.find(commented.level)
				commented.add_points(-(@level_xp_commented.get_follower/2).to_i, category: 'liker')
			end
			#Check level 
			i = commented.level
			unless i == 1
				while commented.points < LevelXp.find(i-1).total_xp_required
					i -= 1
					commented_real_level = i
					if i == 1
						break
					end
				end
			end
			if commented_real_level
				if commented_real_level < commented.level
					#level down user
					commented.update(
						level: commented_real_level
					)
					#Delete notifications
                    Notification.where(user_id: commented.id, notification_type: "level_up").each do |notification|
                        if notification.trackable_id > commented_real_level
                            notification.destroy
                        end
                    end
				end
			end
		end
	end	

end