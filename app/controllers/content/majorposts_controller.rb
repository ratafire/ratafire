class Content::MajorpostsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_majorpost, except: [:create]
	before_filter :load_user, only:[:show, :set_category, :set_sub_category]
	before_filter :show_contacts, only:[:show]
	before_filter :show_followed, only:[:show]

	#REST Methods -----------------------------------

	#content_majorposts POST
	#/content/majorposts
	def create
		#Create the majorpost
		@majorpost = Majorpost.new(majorpost_params)
		#Detect language
		if language = CLD.detect_language(@majorpost.content)
			@majorpost.locale = language[:code]
		end
		#Set majorpost campaign
		if current_user.active_campaign
			@majorpost.campaign_id = current_user.active_campaign.id
		end
		#Update Majorpost
		if @majorpost.update(
				published_at: Time.now,
				user_id: current_user.id,
				excerpt: ActionView::Base.full_sanitizer.sanitize(@majorpost.content).squish.truncate(140)
			) 
			#Update activity
			update_majorpost_activity
			#Update audio
			update_majorpost_audio
			#Cleanup artwork
			Resque.enqueue(Image::ArtworkMajorpostCleanup, params[:majorpost_uuid])
		else
			flash[:error] = @majorpost.errors.full_messages.to_sentence
		end	
		#Create a popover random class for js unique refresh
		@popoverclass = SecureRandom.hex(16)
		#Check whether the artworks are in the content of the majorpost, if not, delete them
	end

	#content_majorpost GET
	#/content/majorposts/:id
	def show
		#Mark the activity as read
		if user_signed_in?
			if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
				@activity.mark_as_read! :for => current_user
			end
		end
		@majorpost_likers = @majorpost.liked_majorposts.page(params[:page]).per_page(5)
		@popoverclass = SecureRandom.hex(16)
	end

	#content_majorpost DELETE
	#/content/majorposts/:id
	def destroy
		#Set Majorpost as deleted
		@majorpost.update(
			deleted: true,
			deleted_at: Time.now
			)
		#Delete majorpost activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@activity.update(
				deleted: true,
				deleted_at: @majorpost.deleted_at
				)
		end
		#Delete Artwork Links Audios Videos
		Resque.enqueue(Majorpost::MajorpostCleanup, params[:majorpost_uuid])
	end	

	#NoREST Methods -----------------------------------

	#content_majorpost_read_more GET
	#/content/majorposts/:majorpost_id/read_more
	def read_more
	end

	#content_majorpost_set_category POST
	def set_category
		if @majorpost.update(
			category: params[:category_id],
			sub_category: nil
		)
			if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
				@activity.update(
					category: @majorpost.category
				)
			end
		end
	end

	#content_majorpost_set_sub_category POST
	def set_sub_category
		if @majorpost.update(
			category: params[:category_id],
			sub_category: params[:sub_category_id]
		)
			if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
				@activity.update(
					category: @majorpost.category,
					sub_category: @majorpost.sub_cateory
				)
			end
		end
	end

private

	def load_user
		@user = @majorpost.user
	end

	def load_majorpost
		unless @majorpost = Majorpost.find_by_uuid(params[:id])
			unless @majorpost = Majorpost.find_by_uuid(params[:majorpost_id])
			end
		end
	end

	def update_majorpost_activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@activity.update(
				category: @majorpost.category,
				sub_category: @majorpost.sub_category,
				published: @majorpost.published,
				tag_list: @majorpost.tag_list
			)
		end
	end

	def update_majorpost_audio
		if @majorpost.post_type == "audio"
			#update info
			@majorpost.audio.update(
				title: @majorpost.title,
				composer: @majorpost.composer,
				artist: @majorpost.artist,
				genre: @majorpost.genre,
				description: @majorpost.content
			)
			#give the audio a default image
			AudioImage.create(
				skip_everafter: true,
				audio_uuid: @majorpost.audio.uuid,
				majorpost_uuid: @majorpost.uuid,
				user_id: @majorpost.user_id
			)
		end
	end

	def majorpost_params
		params.require(:majorpost).permit(:user_id,:title, :content,:post_type, :tag_list, :uuid, :published, :published_at, :paid_update, :composer, :artist, :genre)
	end

	def show_followed
		if user_signed_in?
			@followed = current_user.likeds.order("last_seen desc").page(params[:followed_update]).per_page(3)
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

end