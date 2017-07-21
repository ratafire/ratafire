class VideoImage < ActiveRecord::Base

	#----------------Utilities----------------

    #AWS S3
    require 'aws-sdk-v1'
    require 'aws-sdk'    

    #Environment-specific direct upload url verifier screens for malicious posted upload locations.
    DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #Before filters
    before_create :set_upload_attributes, :unless => :skip_everafter
    after_create :transfer_and_cleanup, :unless => :skip_everafter

    #--------Friendlyid--------
    extend FriendlyId
    friendly_id :uuid

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
    belongs_to :majorpost, class_name: "Majorpost"
    	belongs_to :video, class_name:"video"

    #----------------Attachment----------------
    #image
    has_attached_file :image, 
        :styles => { 
            :preview800 => ["800", :jpg], 
            :preview512 => ["512", :jpg],
            :preview256 => ["256", :jpg], 
            :thumbnail512 => ["512x512#",:jpg],
            :thumbnail128 => ["128x128#",:jpg],
            :thumbnail64 => ["64x64#",:jpg], 
        }, 
        :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
        :url =>  "/:class/uploads/:id/image/:style/:uuid_video_image_filename",
        #If s3
        :path => "/:class/uploads/:id/image/:style/:uuid_video_image_filename",
        :bucket => "Ratafire_production",
        :storage => :s3,
        :s3_region => 'us-east-1',
        :s3_permissions => "private"

        validates_attachment :image, 
            :content_type => { 
                :content_type => [
                    "image/jpeg",
                    "image/jpg",
                    "image/png",
                    "image/bmp"
                ]
            },
            :size => { 
                :in => 0..524288.kilobytes
            }          

    #----------------S3 Direct Upload----------------

    # Make a uuid filename for the file
    Paperclip.interpolates :uuid_video_image_filename do |attachment, style|
        attachment.instance.video_image_uuid_to_filename
    end

    def video_image_uuid_to_filename
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
        self.image = URI.parse(URI.escape(self.direct_upload_url))
        self.save
        s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
    end 

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(12)
        end while VideoImage.find_by_uuid(self.uuid).present?
    end

    # Set attachment attributes from the direct upload
    # @note Retry logic handles S3 "eventual consistency" lag.
    def set_upload_attributes
        tries ||= 5
        direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
        s3 = AWS::S3.new
        #For video
        direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head
        self.image_file_name     = direct_upload_url_data[:filename]
        self.image_file_size     = direct_upload_head.content_length
        self.image_content_type  = direct_upload_head.content_type
        self.image_updated_at    = direct_upload_head.last_modified
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