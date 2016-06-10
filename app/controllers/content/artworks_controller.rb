class Content::ArtworksController < ApplicationController

	protect_from_forgery :except => [:create]

	#Before filters

	#REST Methods -----------------------------------

	#content_artworks GET
	def index
	end

	#content_artworks POST
	#S3 direct upload
	def create
		@artwork = current_user.artwork.create(artwork_params)
	end

	#new_content_artwork GET
	def new
	end

	#edit_content_artwork GET
	def edit
	end

	#content_artwork GET
	def show
	end

	#content_artwork PATCH
	def update
	end

	#content_artwork DELETE
	def destroy
		if @artwork = Artwork.find_by_uuid(params[:id])
			@artwork.destroy
		end
		render nothing: true
	end

	#content_artwork_remove DELETE
	def remove
		#Remove Artwork
		if @artwork = Artwork.find_by_uuid(params[:artwork_id])
			@artwork_uuid = @artwork.uuid		
			@artwork.destroy
		else
			#Remove Audio Image
			if @audio_image = AudioImage.find_by_uuid(params[:artwork_id])
				@artwork_uuid = @audio_image.uuid
				@audio = Audio.find_by_uuid(@audio_image.audio_uuid)
				@audio_image.destroy
			else
				#Remove Video Image
				if @video_image = VideoImage.find_by_uuid(params[:artwork_id])
					@artwork_uuid = @video_image.uuid
					@video = Video.find_by_uuid(@video_image.video_uuid)
					@video_image.destroy
				end
			end
		end
		#render something
	end

	#NoREST Methods -----------------------------------

	#medium_editor_upload_artwork POST
	def medium_editor_upload
		@artwork = Artwork.new(artwork_params)
		if @artwork.update(
			skip_everafter: true, #Not process by the S3 direct upload code
			user_id: current_user.id,
			majorpost_uuid: params[:majorpost_uuid]
			)
			url_response = {files:[{url: @artwork.image.url, id: @artwork.uuid}]}
			render :json => url_response
			#Queue to clean up artwork if it has no majorpost
			Resque.enqueue_in(5.days,Image::ArtworkDelayedCleanup, @artwork.uuid)
		end
	end

	#medium_editor_upload_artwork_campaign POST
	def medium_editor_upload_campaign
		@artwork = Artwork.new(artwork_params)
		if @artwork.update(
			skip_everafter: true, #Not process by the S3 direct upload code
			user_id: current_user.id,
			campaign_uuid: params[:campaign_uuid]
		)
		url_response = {files:[{url: @artwork.image.url, id: @artwork.uuid}]}
		render :json => url_response
		#Queue to clean up artwork if it has no majorpost
		Resque.enqueue_in(5.days,Image::ArtworkDelayedCleanup, @artwork.uuid)
	end

private

	def artwork_params
		params.require(:artwork).permit(:user_id,:majorpost_id, :image, :direct_upload_url, :majorpost_uuid, :campaign_uuid)
	end	

end