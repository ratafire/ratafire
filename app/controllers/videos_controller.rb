class VideosController < ApplicationController

    require 'aws/s3'

    protect_from_forgery :except => [:encode_notify, :create_project_video, :create_majorpost_video]

   def show
       @video = Video.find(params[:id])
   end

   def new
       @video = Video.new
    end

    def create_project_video
        #Create project Video
          @video = Video.new(params[:video])
          @video.user_id = params[:user_id]
          project = Project.find_by_slug(params[:project_id])
          @video.project_id = project.id
          @video.save
          project.video_id = @video.id
          project.save
    end

    def create_majorpost_video
      @video = Video.new(params[:video])
      @video.user_id = params[:user_id]
      project = Project.find_by_slug(params[:project_id])
      majorpost = Majorpost.find_by_slug(params[:majorpost_id])
      @video.project_id = project.id
      @video.majorpost_id = majorpost.id
      @video.save
      majorpost.video_id = @video.id
      majorpost.save
      @video.encode!
    end

    def add_external_video
      @video = Video.new()
      @video.direct_upload_url = params[:external]
      @video.content_temp = params[:content_temp]
      @video.tags_temp = params[:tags_temp]
      @video.user_id = params[:user_id]
      @video.external = params[:external]
      @video.project_id = params[:project_id]
      @video.majorpost_id = params[:majorpost_id]
      @majorpost = Majorpost.find(params[:majorpost_id])
      external_video
      

      if @video.content_temp != nil && @video.content_temp != "" then
        @majorpost.content = @video.content_temp
        if @video.tags_temp != nil && @video.tags_temp != "" then
          tags = @video.tags_temp.split(",")
          @majorpost.tag_list = tags
        end
        @majorpost.save
      end

        #Clean up the temp
        @video.content_temp = nil
        @video.tags_temp = nil
        @video.save   
      redirect_to(:back)     
    end

    def create_external_video
      external_video
      redirect_to(:back)
    end

    def destroy
        @video = Video.find(params[:id])
        @project = @video.project
        @majorpost = @video.majorpost
        #it is either a majorpost video or a project video
        if @video.majorpost_id == nil then
           @project.video_id = nil
           @project.save
        else
            @majorpost.video_id = nil
            @majorpost.save
        end
        @video.destroy
        flash[:success] = "Video deleted."
        redirect_to(:back)
    end

  # if you're not using swfupload, code like this would be in your create and update methods
  # all you really need to ensure is that after @video.save, you run @video.encode!
  #def swfupload
  #  @video = Video.new(params[:video])
  #  @video.swfupload_file = params[:Filedata]
    # if we're in production, test should be nil but otherwise we're going to want to encode
    # videos using Zencoder's test setting so we're not spending cash to do so
  #  RAILS_ENV == "production" ? test = {} : test = {:test => 1}
  #  if @video.save && @video.encode!(test)
  #    render :json => {:message => "Video was successfully uploaded.  Encoding has commenced automatically."}
  #  else
  #    render :json => {:errors => @video.errors.full_messages.to_sentence.capitalize}
  #  end
  #end

    # capture notifications from the Zencoder service about video encoding
    def encode_notify
        # get the job id so we can find the video
        video = Video.find_by_job_id(params[:job][:id].to_i)
        video.capture_notification(params[:output]) if video
        render :text => "Thanks, Zencoder!", :status => 200
    end

    # retrive zencoder video settings
    def zencoder_setting
        @zencoder_config ||= YAML.load_file("#{RAILS_ROOT}/config/zencoder.yml")
    end

 private
 
    #process external video
    def external_video
        #youtube
        #@majorpost = Majorpost.find(@video.majorpost_id)
        @video_regexp = [ /^(?:https?:\/\/)?(?:www\.)?youtube\.com(?:\/v\/|\/watch\?v=)([A-Za-z0-9_-]{11})/, 
                   /^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([A-Za-z0-9_-]{11})/,
                   /^(?:https?:\/\/)?(?:www\.)?youtube\.com\/user\/[^\/]+\/?#(?:[^\/]+\/){1,4}([A-Za-z0-9_-]{11})/
                   ]
        #vimeo
        if @video.external =~ /^(http|https):\/\/(?:.*?)\.?vimeo\.com\/(watch\?[^#]*v=(\w+)|(\d+))/ then
            @video.youtube_vimeo = false
            @video.external = @video.external[/^(http|https):\/\/(?:.*?)\.?vimeo\.com\/(watch\?[^#]*v=(\w+)|(\d+))/, 2]
            @video.save
            @majorpost.video_id = @video.id
            flash[:success] = "Vimeo video added."
        else    
          #youtube
          if youtube_video_id(@video.external) != nil then
            @video.youtube_vimeo = true
            @video.external = youtube_video_id(@video.external)
            @video.save
            @majorpost.video_id = @video.id
            flash[:success] = "Youtube video added."
          else
            flash[:success] = "Failed to add external video."
            @majorpost.video_id = nil
            @video.destroy
          end
        end
        @majorpost.save
    end 

    def youtube_video_id(source_url)
      @video_regexp.each { |m| return m.match(source_url)[1] unless m.nil? }
    end  
end