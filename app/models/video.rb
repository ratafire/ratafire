class Video < ActiveRecord::Base

    require 'aws/s3'

    #----------------Utilities----------------

    #Environment-specific direct upload url verifier screens for malicious posted upload locations.
    DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #Before filters
    before_create :set_upload_attributes, :unless => :skip_everafter
    after_create :transfer_and_cleanup, :unless => :skip_everafter
    after_destroy :remove_encoded_video

    #--------Friendlyid--------
    extend FriendlyId
    friendly_id :uuid

    #----------------Scope----------------
    scope :finished, -> { where(encoded_state: "finished") }

    #----------------Relationships----------------
    #Belongs to
    belongs_to :majorpost, class_name:"Majorpost"
    belongs_to :user
    belongs_to :campaign
    #Has one
    has_one :video_image, foreign_key: "video_uuid", primary_key: "uuid", class_name:"VideoImage", dependent: :destroy

    #----------------Attachment----------------
    #Random Filename
    RANDOM_FILENAME = SecureRandom.hex(16)

    #--- Thumbnail Attachment ---

    #Video
    has_attached_file :video,
        :url => ":class/uploads/:id/:style/:uuid_video_filename.:extension",
        :path => ":class/uploads/:id/:style/:uuid_video_filename.:extension",
        :bucket => "Ratafire_production",
        :storage => :s3, # this is redundant if you are using S3 for all your storage requirements
        :s3_region => 'us-east-1'

    validates_attachment :video, 
        :content_type => { 
            :content_type => [
                "video/avi",
                "video/mp4",
                "video/mov",
                "video/mpeg4",
                "video/wmv",
                "video/flv",
                "video/3gpp", 
                "video/webm", 
                "video/quicktime"
            ]
        },
        :size => { 
            :in => 0..5242880.kilobytes
        }  

    #Thumbnail
  	has_attached_file :thumbnail, 
        :styles => { 
            :preview720p => ["1080x720#", :jpg],
            :preview480p => ["640x480#",:jpg],
            :preview360p => ["480x360#",:jpg],
            :preview800 => ["800", :jpg], 
            :preview512 => ["512", :jpg],
            :preview256 => ["256", :jpg], 
            :thumbnail512 => ["512x512#",:jpg],
            :thumbnail256 => ["256x256#",:jpg],
            :thumbnail128 => ["128x128#",:jpg],
            :thumbnail64 => ["64x64#",:jpg], 
            }, 
        :bucket => "Ratafire_production",
        :storage => :s3,
        :s3_region => 'us-east-1'

    validates_attachment :thumbnail, 
    	:content_type => { 
    		:content_type => [
    			"image/jpeg",
    			"image/jpg",
    			"image/png",
    			"image/bmp"
    		]
    	},
    	:size => { 
    		:in => 0..15000.kilobytes #15mb
    	}        


    #----------------S3 Direct Upload----------------

    # Make a uuid filename for the file
    Paperclip.interpolates :uuid_video_filename do |attachment, style|
        attachment.instance.video_uuid_to_filename
    end

    def video_uuid_to_filename
        "#{self.uuid}"
    end

    # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
    def direct_upload_url=(escaped_url)
        write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
    end

    # Final upload processing step
    def transfer_and_cleanup
        direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(self.direct_upload_url)
        s3 = AWS::S3.new
        self.video = URI.parse(URI.escape(self.direct_upload_url))
        self.save
        s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
    end

    #----------------Zencoder Encoder---------------- 

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

private

    def zencoder_setting
        @zencoder_config ||= YAML.load_file("#{Rails.root}/config/zencoder.yml")
    end

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Video.find_by_uuid(self.uuid).present?
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

end