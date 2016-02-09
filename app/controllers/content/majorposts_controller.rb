class Content::MajorpostsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_majorpost, except: [:create]

	#After filters
	after_filter :prepare_unobtrusive_flash

	def new
	end
	
	def create
		#Create the majorpost
		@majorpost = Majorpost.new(majorpost_params)
		if @majorpost.update(
				published_at: Time.now,
				user_id: current_user.id
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

	def update
	end

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

private

	def load_majorpost
		@majorpost = Majorpost.find_by_uuid(params[:id])
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