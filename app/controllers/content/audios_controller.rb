class Content::AudiosController < ApplicationController

	protect_from_forgery :except => [:create]

	#Before filters

	#REST Methods -----------------------------------

	#content_audios GET
	def index
	end

	#content_audios POST
	#S3 direct upload
	def create
		if params[:audio][:soundcloud]
			#External audio
			if params[:audio][:soundcloud] =~ /^https?:\/\/(?:www.)?soundcloud.com\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*(?!\/sets(?:\/|$))(?:\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*){1,2}\/?$/i 
				client = Soundcloud.new(:client_id => ENV["SOUNDCLOUD_CLIENT_ID"])
				track = client.get('/resolve', :url => params[:audio][:soundcloud])
				@audio = current_user.audio.new(audio_params)
				@audio.update(
					skip_everafter: true,
					soundcloud: track.id,
					soundcloud_image: track.artwork_url.gsub("large.jpg","t500x500.jpg")
					)
			else
				flash[:error] = "Fail to add SoundCloud audio."
			end	
		else
			#Internal audio
			@audio = current_user.audio.create(audio_params)
		end
	end

	#new_content_audio GET
	def new
	end

	#edit_content_audio GET
	def edit
	end

	#content_audio GET
	def show
	end

	#content_audio PATCH
	def update
	end

	#content_audio DELETE
	def destroy
		if @audio = Audio.find_by_uuid(params[:id])
			@audio.destroy
		end
	end


	#NoREST Methods -----------------------------------

private

	def audio_params
		params.require(:audio).permit(:user_id,:audio, :direct_upload_url, :majorpost_uuid, :soundclound_image)
	end	

end