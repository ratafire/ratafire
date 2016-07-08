class Content::MajorpostsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_majorpost, except: [:create]

	#After filters
	after_filter :prepare_unobtrusive_flash

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
		@user = @majorpost.user
		#Mark the activity as read
		if user_signed_in?
			if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
				@activity.mark_as_read! :for => current_user
			end
		end
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

private

	def load_majorpost
		unless @majorpost = Majorpost.find_by_uuid(params[:id])
			unless @majorpost = Majorpost.find_by_uuid(params[:majorpost_id])
			end
		end
	end

	def update_majorpost_activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@activity.update(
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

end