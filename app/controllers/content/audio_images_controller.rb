class Content::AudioImagesController < ApplicationController

	protect_from_forgery :except => [:create]

	#Before filters

	#REST Methods -----------------------------------

	#content_audio_images GET
	def index
	end

	#content_audio_images POST
	#S3 direct upload
	def create
		@audio_image = current_user.audio_image.create(audio_image_params)
	end

	#new_content_audio_image GET
	def new
	end

	#edit_content_audio_image GET
	def edit
	end

	#content_audio_image GET
	def show
	end

	#content_audio_image PATCH
	def update
	end

	#content_audio_image DELETE
	def destroy
	end

	#content_audio_image_remove DELETE
	def remove
	end

	#NoREST Methods -----------------------------------

private

	def audio_image_params
		params.require(:audio_image).permit(:user_id,:audio_uuid,:image, :direct_upload_url, :majorpost_uuid)
	end	

end