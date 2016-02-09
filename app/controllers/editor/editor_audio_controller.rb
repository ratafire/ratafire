class Editor::EditorAudioController < ApplicationController

	#Before filters
	before_filter :load_user, only: [:new]

	#REST Methods -----------------------------------
	
	#new_user_editor_editor_text GET
	#Show text editor	
	def new
		#Generate uuid for majorpost
		generate_uuid!
		@majorpost = Majorpost.new(
				user_id: @user.id,
				uuid: @uuid
			)
		@audio = Audio.new(
				user_id: @user.id,
				majorpost_uuid: @uuid			
			)		
		@upload_url = '/content/artworks/medium_editor_upload_artwork/'+@majorpost.uuid
	end

	#NoREST Methods -----------------------------------

	#remove_user_editor_editor_audio GET
	#Hide text editor
	def remove
		#Clean up unused rtwork
		if Artwork.find_by_majorpost_uuid(params[:majorpost_uuid])
			Resque.enqueue(Image::ArtworkCleanup, params[:majorpost_uuid])
		end
		#Clean up unused audio
		if @audio = Audio.find_by_majorpost_uuid(params[:majorpost_uuid])
			@audio.destroy
		end		
	end

protected

	def load_user
		@user = User.find(params[:user_id])
	end

	def load_majorost
		@majorpost = Majorpost.find_by_uuid(params[:id])
	end

    def generate_uuid!
        begin
            @uuid = SecureRandom.hex(6)
        end while Majorpost.find_by_uuid(@uuid).present?
    end	

end