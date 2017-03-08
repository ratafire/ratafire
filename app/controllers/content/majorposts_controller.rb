class Content::MajorpostsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_majorpost, except: [:create]
	before_filter :load_user, only:[:show, :set_category, :set_sub_category]
	before_filter :show_contacts, only:[:show]
	before_filter :show_followed, only:[:show]
	before_filter :meta_majorpost, only:[:show]

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

	def update
		@majorpost.update(majorpost_params)
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
		Resque.enqueue(Majorpost::MajorpostCleanup, @majorpost.uuid)
	end	

	#NoREST Methods -----------------------------------

	#content_majorpost_read_more GET
	#/content/majorposts/:majorpost_id/read_more
	def read_more
		if @majorpost.backers_only == true
			if user_signed_in? 
				unless current_user == @majorpost.user
					if @majorpost.user.subscribed_by?(current_user.id)
						@read_more = true
					else
						if @subscription = Subscription.where(subscriber_id: current_user.id, subscribed_id: @majorpost.user.id, funding_type: 'one_time').last
							if (Time.now - @subscription.created_at) <= 604800
								@read_more = true
							else
								# read_more is false
							end
						end
					end
				else
					@read_more = true
				end
			else
				# reead_more is false
			end
		else
			@read_more = true
		end
	end

	#content_majorpost_set_category POST
	def set_category
		if @majorpost.update(
			category: params[:category_id],
			sub_category: nil
		)
			if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
				@activity.update(
					category: params[:category_id],
					sub_category: nil
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
					category: params[:category_id],
					sub_category: params[:sub_category_id]
				)
			end
		end
	end

	#content_majorpost_set_as_backers_only POST
	def set_as_backers_only
		@majorpost.update(
			backers_only: true
		)
	end

	#content_majorpost_set_as_public POST
	def set_as_public
		@majorpost.update(
			backers_only: nil
		)
	end

	#content_majorpost_edit GET
	#/content/majorposts/:majorpost_id/edit
	def edit
		@upload_url = '/content/artworks/medium_editor_upload_artwork/'+@majorpost.uuid
	end

	#content_majorpost_cancel_edit GET
	def cancel_edit
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

	def meta_majorpost
		case @majorpost.post_type
		when "video"
			#Normal meta tag
			if @majorpost.video.external != "" && @majorpost.video.external != nil 
				if @majorpost.video.youtube_vimeo == true
					#Youtube
					if youtube = VideoInfo.new('https://youtube.com/watch?v='+@majorpost.video.external)
						#Normal meta tag
						set_meta_tags title: I18n.t('ratafire') + ' - ' + @majorpost.title + ' - ' + @user.preferred_name,
									  description: @majorpost.excerpt,
									  image_src: youtube.thumbnail_large,
									  video: 'https://youtube.com/' + @majorpost.video.external
						#Open Graph Object
						set_meta_tags og: {
							title: @majorpost.title,
							type:     'video.movie',
							url:      'https://youtube.com/watch?v='+@majorpost.video.external,
							video:    'https://youtube.com/watch?v='+@majorpost.video.external,
							author: @user.preferred_name
						}
						#Twitter Card
						set_meta_tags twitter: {
							card:  "player",
							player: 'https://youtube.com/watch?v='+@majorpost.video.external,
							creator: @user.preferred_name,
							title: @majorpost.title,
							description: @majorpost.excerpt,
							image: youtube.thumbnail_large,
							author: @user.preferred_name
						}
					end
				else
					#Vimeo
					if vimeo = VideoInfo.new('https://vimeo.com/'+@majorpost.video.external)
						#Normal meta tag
						set_meta_tags title: I18n.t('ratafire') + ' - ' + @majorpost.title + ' - ' + @user.preferred_name,
									  description: @majorpost.excerpt,
									  image_src: youtube.thumbnail_large,
									  video: 'https://vimeo.com/' + @majorpost.video.external,
									  author: @user.preferred_name
						#Open Graph Object
						set_meta_tags og: {
							title: @majorpost.title,
							type:     'video.movie',
							url:      'https://vimeo.com/'+@majorpost.video.external,
							video:    'https://vimeo.com/'+@majorpost.video.external,
							author: @user.preferred_name
						}
						#Twitter Card
						set_meta_tags twitter: {
							card:  "player",
							player: 'https://vimeo.com/'+@majorpost.video.external,
							creator: @user.preferred_name,
							title: @majorpost.title,
							description: @majorpost.excerpt,
							image: youtube.thumbnail_large,
							author: @user.preferred_name
						}
					end
				end
			else
				#Internal Video
				#Normal meta tag
				set_meta_tags title: I18n.t('ratafire') + ' - ' + @majorpost.title + ' - ' + @user.preferred_name,
							  description: @majorpost.excerpt,
							  image_src: @majorpost.video.thumbnail(:preview800),
							  author: @user.preferred_name
				#Open Graph Object
				set_meta_tags og: {
					title: @majorpost.title,
					type:     'website',
					image: @majorpost.video.thumbnail(:preview800),
					description: @majorpost.excerpt,
					author: @user.preferred_name
				}
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary_large_image",
					site: "ratafire.com",
					creator: @user.preferred_name,
					title: @majorpost.title,
					description: @majorpost.excerpt,
					image: @majorpost.video.thumbnail(:preview800),
					author: @user.preferred_name
				}
			end
		when 'image', 'text'
			if @majorpost.artwork.any?
				#Normal meta tag
				set_meta_tags title: I18n.t('ratafire') + ' - ' + @majorpost.title + ' - ' + @user.preferred_name,
							  description: @majorpost.excerpt,
							  image_src: @majorpost.artwork.first.image.url(:preview800),
							  author: @user.preferred_name
				#Open Graph Object
				set_meta_tags og: {
					title: @majorpost.title,
					type:     'website',
					image: @majorpost.artwork.first.image.url(:preview800),
					author: @user.preferred_name
				}
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary_large_image",
					site: "ratafire.com",
					creator: @user.preferred_name,
					title: @majorpost.title,
					description: @majorpost.excerpt,
					image: @majorpost.artwork.first.image.url(:preview800),
					author: @user.preferred_name
				}
			else
				#Normal meta tag
				set_meta_tags title: I18n.t('ratafire') + ' - ' + @majorpost.title + ' - ' + @user.preferred_name,
							  description: @majorpost.excerpt,
							  image_src: @user.profilephoto.image.url(:original),
							  author: @user.preferred_name
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary",
					site: "ratafire.com",
					creator: @user.preferred_name,
					title: @majorpost.title,
					description: @majorpost.excerpt,
					image: @user.profilephoto.image.url(:thumbnail256),
					author: @user.preferred_name
				}
			end
		when 'audio'
			if @majorpost.audio.soundcloud != "" && @majorpost.audio.soundcloud != nil
				#Soundcloud
				#Normal meta tag
				set_meta_tags title: I18n.t('ratafire') + ' - ' + @majorpost.title + ' - ' + @user.preferred_name,
							  description: @majorpost.excerpt,
							  image_src: @majorpost.audio.soundcloud_image,
							  author: @user.preferred_name
				#Open Graph Object
				set_meta_tags og: {
					title: @majorpost.title,
					type:     'website',
					url: 'https://soundcloud.com/'+@majorpost.soundcloud,
					author: @user.preferred_name
				}
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary_large_image",
					site: "ratafire.com",
					creator: @user.preferred_name,
					title: @majorpost.title,
					description: @majorpost.excerpt,
					image: @majorpost.audio.soundcloud_image,
					author: @user.preferred_name
				}
			else
				#Normal meta tag
				set_meta_tags title: I18n.t('ratafire') + ' - ' + @majorpost.title + ' - ' + @user.preferred_name,
							  description: @majorpost.excerpt,
							  image_src: @majorpost.audio.audio_image.image.url(:preview800),
							  author: @user.preferred_name
				#Open Graph Object
				set_meta_tags og: {
					title: @majorpost.title,
					type:     'website',
					image: @majorpost.audio.audio_image.image.url(:preview800),
					author: @user.preferred_name
				}
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary_large_image",
					site: "ratafire.com",
					creator: @user.preferred_name,
					title: @majorpost.title,
					description: @majorpost.excerpt,
					image: @majorpost.audio.audio_image.image.url(:preview800),
					author: @user.preferred_name
				}
			end
		when 'link'
			#Normal meta tag
			set_meta_tags title: I18n.t('ratafire') + ' - ' + @majorpost.title + ' - ' + @user.preferred_name,
						  description: @majorpost.excerpt,
						  image_src: @majorpost.try(:link).try(:image_best),
						  author: @user.preferred_name
			#Open Graph Object
			set_meta_tags og: {
				title: @majorpost.title,
				type:     'website',
				url: @majorpost.try(:link).try(:url),
				author: @user.preferred_name
			}
			if @majorpost.try(:link).try(:image_best)
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary_large_image",
					site: "ratafire.com",
					creator: @user.preferred_name,
					title: @majorpost.title,
					description: @majorpost.excerpt,
					image: @majorpost.try(:link).try(:image_best),
					author: @user.preferred_name
				}
			else
				#Twitter Card
				set_meta_tags twitter: {
					card:  "summary",
					site: "ratafire.com",
					creator: @user.preferred_name,
					title: @majorpost.title,
					description: @majorpost.excerpt,
					image: @user.profilephoto.image.url(:thumbnail256),
					author: @user.preferred_name
				}
			end
		end
	rescue
		#Because the video info maybe nil
	end

	def update_majorpost_activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@activity.update(
				key: 'post.create',
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