class Content::LinksController < ApplicationController

	#Before filters

	#REST Methods -----------------------------------

	#content_links GET
	def index
	end

	#content_link POST
	#S3 direct upload
	def create
		#nitialize a MetaInspector instance for an URL
		@link= Link.new(link_params)
		page = MetaInspector.new(@link.url)
		if page.response.status == 200
			@link.update(
				user_id: current_user.id,
				image_best: page.images.best,
				description: page.description,
				best_title: page.best_title,
				title: page.title,
				root_url: page.root_url,
				host: page.host,
				tracked: page.tracked?,     
				)
		end
	end

	#new_content_link GET
	def new
	end

	#edit_content_link GET
	def edit
	end

	#content_link GET
	def show
	end

	#content_link PATCH
	def update
	end

	#content_link DELETE
	def destroy
		if @link = Link.find_by_uuid(params[:link_id])
			@link_uuid = @link.uuid
			@link.destroy
		end
	end

	#NoREST Methods -----------------------------------

	#medium_editor_upload_link POST
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

private

	def link_params
		params.require(:link).permit(:user_id,:majorpost_uuid, :url)
	end	

end