class Content::VideosController < ApplicationController

	protect_from_forgery :except => [:create, :encode_notify]

	#Before filters
	respond_to :html, :js

	#REST Methods -----------------------------------

	#content_videos GET
	def index
	end

	#content_videos POST
	#S3 direct upload
	def create
		if params[:video][:external]
			@video = current_user.video.new(video_params)
			#External audio
			if params[:video][:external] =~ /^(http|https):\/\/(?:.*?)\.?vimeo\.com\/(watch\?[^#]*v=(\w+)|(\d+))/
				#Add Vimeo Video
				@video.update(
					skip_everafter: true,
					external: params[:video][:external][/^(http|https):\/\/(?:.*?)\.?vimeo\.com\/(watch\?[^#]*v=(\w+)|(\d+))/, 2],
					youtube_vimeo: false
					)
			else
				@youtube_regexp = [ /^(?:https?:\/\/)?(?:www\.)?youtube\.com(?:\/v\/|\/watch\?v=)([A-Za-z0-9_-]{11})/, 
                   /^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([A-Za-z0-9_-]{11})/,
                   /^(?:https?:\/\/)?(?:www\.)?youtube\.com\/user\/[^\/]+\/?#(?:[^\/]+\/){1,4}([A-Za-z0-9_-]{11})/
                   ]
				if youtube = youtube_video_id(params[:video][:external])
					@video.update(
						skip_everafter: true,
						external: youtube,
						youtube_vimeo: true
						)
				else
					flash[:error] = "Fail to add video."
				end
			end	
		else
			#Internal video
			@video = current_user.video.create(video_params)
			@video.encode!
		end
	end

	#new_content_video GET
	def new
	end

	#edit_content_video GET
	def edit
	end

	#content_video GET
	def show
	end

	#content_video PATCH
	def update
	end

	#content_video DELETE
	def destroy
		if @video = Video.find_by_uuid(params[:id])
			@video.destroy
		end
	end


	#NoREST Methods -----------------------------------
	
	# capture notifications from the Zencoder service about video encoding
	# zencoder_fetcher 8fa049ee1d0050ea8bd520d085f128a9 --url http://localhost:3000/video/zencoder_notify_encode
	def encode_notify
		# get the job id so we can find the video
		@video = Video.find_by_job_id(params[:job][:id].to_i)
		@video.capture_notification(params[:output]) if @video
		render :text => "Thanks, Zencoder!", :status => 200
		#respond_to do |format|
	    #  format.js { render :action => 'encode_notify'}
	    #  format.html { render :action => 'encode_notify', :formats=>[:js]}
		#end
	end

private

	def youtube_video_id(source_url)
		@youtube_regexp.each { |m| return m.match(source_url)[1] unless m.nil? }
	end

	def video_params
		params.require(:video).permit(:user_id,:video, :direct_upload_url, :majorpost_uuid, :external)
	end	

end