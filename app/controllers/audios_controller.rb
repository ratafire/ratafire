class AudiosController < ApplicationController

	SEND_FILE_METHOD = :default

	protect_from_forgery :except => [:create_project_audio, :create_majorpost_audio]

	require 'soundcloud'

def create
  @audio = Audio.create(params[:audio])
#  render json: {:success => true, :audio_id => @audio.id}
	#Content temp, this is to save the current content the user is editing...
	if @audio.majorpost_id != nil then # it is a majorpost
		if @audio.content_temp != nil && @audio.content_temp != "" then
			@majorpost = Majorpost.find(@audio.majorpost_id)
			@majorpost.content = @audio.content_temp
			if @audio.tags_temp != nil && @audio.tags_temp != "" then
				tags = @audio.tags_temp.split(",")
				@majorpost.tag_list = tags
			end
			@majorpost.save
		end
	else
		if @audio.content_temp != nil && @audio.content_temp != "" then
			@project = Project.find(@audio.project_id)
			@project.about = @audio.content_temp
			if @audio.tags_temp != nil && @audio.tags_tmep != "" then
				tags = @audio.tags_temp.split(",")
				@project.tag_list = tags
			end
			@project.save
		end	
	end
	#Clean up the temp
	@audio.content_temp = nil
	@audio.tags_temp = nil
	@audio.save
end	

def create_project_audio
	#Create project Audio
	@audio = Audio.new(params[:audio])
	@audio.user_id = params[:user_id]
	project = Project.find_by_slug(params[:project_id])
	@audio.project_id = project.id
	@audio.save
	project.audio_id = @audio.id
	project.save
end

def create_majorpost_audio
	#Create majorpost Audio
	@audio = Audio.new(params[:audio])
	@audio.user_id = params[:user_id]
	project = Project.find_by_slug(params[:project_id])
	majorpost = Majorpost.find_by_slug(params[:majorpost_id])
	@audio.project_id = project.id
	@audio.majorpost_id = majorpost.id
	@audio.save
	majorpost.audio_id = @audio.id
	majorpost.save
end

def add_external_audio
      @audio = Audio.new()
      @audio.direct_upload_url = params[:external]
      @audio.content_temp = params[:content_temp]
      @audio.tags_temp = params[:tags_temp]
      @audio.user_id = params[:user_id]
      @audio.soundcloud = params[:external]
      @audio.project_id = params[:project_id]
      @audio.majorpost_id = params[:majorpost_id]
      @majorpost = Majorpost.find(params[:majorpost_id])
      external_audio
      

      if @audio.content_temp != nil && @audio.content_temp != "" then
        @majorpost.content = @audio.content_temp
        if @audio.tags_temp != nil && @audio.tags_temp != "" then
          tags = @audio.tags_temp.split(",")
          @majorpost.tag_list = tags
        end
        @majorpost.save
      end

        #Clean up the temp
        @audio.content_temp = nil
        @audio.tags_temp = nil
        @audio.save   
      redirect_to(:back)     
end


def destroy
	@audio = Audio.find(params[:id])
	#if Audio belongs to majorpost
	if @audio.majorpost != nil
		@majorpost = @audio.majorpost
		@majorpost.audio_id = nil
		@majorpost.save
	else #Audio belongs to project
		@project = @audio.project
		@project.audio_id = nil
		@project.save
	end
	@audio.destroy
	flash[:success] = "Audio deleted."
	redirect_to(:back)
end

private

#process external audio
def external_audio

	#SoundCloud
	if @audio.soundcloud =~ /^https?:\/\/(?:www.)?soundcloud.com\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*(?!\/sets(?:\/|$))(?:\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*){1,2}\/?$/i then
		client = Soundcloud.new(:client_id => ENV["SOUNDCLOUD_CLIENT_ID"])
		track = client.get('/resolve', :url => @audio.soundcloud)
		@audio.soundcloud = track.id
		@audio.soundcloud_image = track.artwork_url.gsub("large.jpg","t500x500.jpg")
		@audio.save
		@majorpost.audio_id = @audio.id
		flash[:success] = "SoundCloud audio added."
	else
		flash[:success] = "Failed to add external audio."
		@majorpost.audio_id = nil
		@audio.destroy
	end	
	@majorpost.save
end
end