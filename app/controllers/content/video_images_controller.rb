class Content::VideoImagesController < ApplicationController

	protect_from_forgery :except => [:create]

	#Before filters

	#REST Methods -----------------------------------

	#content_video_images GET
	def index
	end

	#content_video_images POST
	#S3 direct upload
	def create
		@video_image = current_user.video_image.create(video_image_params)
	end

	#new_content_video_image GET
	def new
	end

	#edit_content_video_image GET
	def edit
	end

	#content_video_image GET
	def show
	end

	#content_video_image PATCH
	def update
	end

	#content_video_image DELETE
	def destroy
	end

	#content_video_image_remove DELETE
	def remove
	end

	#NoREST Methods -----------------------------------

private

	def video_image_params
		params.require(:video_image).permit(:user_id,:video_uuid,:image, :direct_upload_url, :majorpost_uuid)
	end	

end