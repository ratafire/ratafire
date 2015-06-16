class Video < ActiveRecord::Base

require 'aws/s3'

  # Environment-specific direct upload url verifier screens for malicious posted upload locations.
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  RANDOM_FILENAME = SecureRandom.hex(16)

  before_create :set_upload_attributes, :unless => :skip_everafter
  after_create :queue_processing, :unless => :skip_everafter
  after_destroy :remove_encoded_video  

  attr_accessible :panda_video_id, :title, :external, :project_id, :majorpost_id,:video, :content_temp, :tags_temp, :archive_id, :direct_upload_url, :skip_everafter
  belongs_to :majorpost
  belongs_to :project
  belongs_to :archive
  belongs_to :user, class_name:"User"
  belongs_to :patron_video

  scope :finished, :conditions => { :encoded_state => "finished" }  

  has_attached_file :video,
  	:url => ":class/uploads/:id/:style/#{RANDOM_FILENAME}.:extension",
  	:path => ":class/uploads/:id/:style/#{RANDOM_FILENAME}.:extension",
  	:storage => :s3 # this is redundant if you are using S3 for all your storage requirements

  validates_attachment :video, 
    :content_type => { :content_type => ["video/avi","video/mp4","video/mov","video/mpeg4","video/wmv","video/flv","video/3gpp", "video/webm"]},
    :size => { :in => 0..2097152.kilobytes}  

  #validates_attachment_presence :video
  has_attached_file :thumbnail, :styles => { :thumb => "171x96#"},
      :storage => :s3

  #process_in_background :thumbnail, :only_process => [:small, :thumbnail

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  # Determines if file requires post-processing (image resizing, etc)
  def post_process_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}.match(video_content_type).present?
  end

  # Final upload processing step
  def self.transfer_and_cleanup(id)
    video = Video.find(id)
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(video.direct_upload_url)
    s3 = AWS::S3.new
    
    if video.post_process_required?
      video.upload = URI.parse(URI.escape(video.direct_upload_url))
    else
      extension = direct_upload_url_data[:filename].split(".")[1]
      paperclip_file_path = "videos/uploads/#{id}/original/#{RANDOM_FILENAME}.#{extension}"
      s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])
    end
 
    video.processed = true
    video.save
    
    s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
  end


  # this runs on the after_destroy callback.  It is reponsible for removing the encoded file
  # and the thumbnail that is associated with this video.  Paperclip will automatically remove the other files, but
  # since we created our own bucket for encoded video, we need to handle this part ourselves.
  def remove_encoded_video
    unless output_url.blank?
      s3 = AWS::S3.new(
        :access_key_id     => zencoder_setting["s3_output"]["access_key_id"],
        :secret_access_key => zencoder_setting["s3_output"]["secret_access_key"]
      )
      bucket = s3.buckets[zencoder_setting["s3_output"]["bucket"]]
      object = bucket.objects[File.basename(output_url)]
      object2 = bucket.objects["thumbnails_#{self.id}/frame_0000.png"]
      object.delete
      object2.delete
    end
  end
  
  # commence encoding of the video.  Width and height are hard-coded into this, but there may be situations where
  # you want that to be more dynamic - that modification will be trivial.
  def encode!(options = {})
    begin
      #Zencoder
      zen = Zencoder.new("http://s3.amazonaws.com/" + zencoder_setting["s3_output"]["bucket"], zencoder_setting["settings"]["notification_url"])
      # 'video.url(:original, false)' prevents paperclip from adding timestamp, which causes errors
      if zen.encode(self.video.url(:original, false), 800, 450, "/thumbnails_#{self.id}", options)
        self.encoded_state = "queued"
        self.output_url = zen.output_url
        self.job_id = zen.job_id
        self.save
      else
        errors.add_to_base(zen.errors)
        nil
      end
    rescue RuntimeError => exception
      errors.add_to_base("Video encoding request failed with result: " + exception.to_s)
      nil
    end
  end

  def project!(options = {})
    begin
      #Add Video to Project
      project = Project.find_by_slug(self.project_id)
      project.video_id = self.id
      project.save
    end
  end
  
  # must be called from a controller action, in this case, videos/encode_notify, that will capture the post params
  # and send them in.  This captures a successful encoding and sets the encode_state to "finished", so that our application
  # knows we're good to go.  It also retrieves the thumbnail image that Zencoder creates and attaches it to the video
  # using Paperclip.  And finally, it retrieves the duration of the video, again from Zencoder.
  def capture_notification(output)
    self.encoded_state = output[:state]
    if self.encoded_state == "finished"
      #Set output url to webm or mp4
      if output[:label] == "webm"
        self.output_url = output[:url]
      else
        self.output_url_mp4 = output[:url]  
      end  
      self.thumbnail = open(URI.parse("http://s3.amazonaws.com/" + zencoder_setting["s3_output"]["bucket"] + "/thumbnails_#{self.id}/frame_0000.png"))
      self.thumbnail_content_type = "image/png"
      # get the job details so we can retrieve the length of the video in milliseconds
      zen = Zencoder.new
      self.duration_in_ms = zen.details(self.job_id)["job"]["output_media_files"].first["duration_in_ms"]
    end
    self.save
  end
  
  # a handy way to turn duration_in_ms into a formatted string like 5:34
  def human_length
    if duration_in_ms
      minutes = duration_in_ms / 1000 / 60
      seconds = (duration_in_ms / 1000) - (minutes * 60)
      sprintf("%d:%02d", minutes, seconds)
    else
      "Unknown"
    end
  end
  
  protected
    
    def zencoder_setting
      @zencoder_config ||= YAML.load_file("#{Rails.root}/config/zencoder.yml")
    end

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
    if self.external == nil then
      tries ||= 5
      direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
      s3 = AWS::S3.new
      direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head
 
      self.video_file_name     = direct_upload_url_data[:filename]
      self.video_file_size     = direct_upload_head.content_length
      self.video_content_type  = direct_upload_head.content_type
      self.video_updated_at    = direct_upload_head.last_modified
    end 
      
    rescue AWS::S3::Errors::NoSuchKey => e
        tries -= 1
        if tries > 0
          sleep(3)
          retry
        else
          false
        end
  end
  
  # Queue file processing
  def queue_processing
    if self.external == nil then
      video = Video.find(id)
      direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(video.direct_upload_url)
      s3 = AWS::S3.new
    
      if video.post_process_required?
          video.video = URI.parse(URI.escape(video.direct_upload_url))
      else
          extension = direct_upload_url_data[:filename].split(".")[1]
          paperclip_file_path = "videos/uploads/#{id}/original/#{RANDOM_FILENAME}.#{extension}"
          s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])
      end
 
      video.processed = true
      video.save
    
      s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
      video.encode!
    end
  end

end
