class RewardUpload < ActiveRecord::Base

	#----------------Utilities----------------

    #AWS S3
    require 'aws-sdk-v1'
    require 'aws-sdk'

    #Environment-specific direct upload url verifier screens for malicious posted upload locations.
    DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

    #Default scope
    default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create

    #Before filters
    before_create :set_upload_attributes, :unless => :skip_everafter
    after_create :transfer_and_cleanup, :unless => :skip_everafter

    #----------------Relationships----------------
    #Belongs to
    belongs_to :rewards

    #----------------Attachment----------------
    #package
    has_attached_file :package,
    	:url => "/:class/uploads/:id/image/:style/:uuid_reward_upload_filename.:extension",
    	:path => "/:class/uploads/:id/image/:style/:uuid_reward_upload_filename.:extension",
    	:bucket => "Ratafire_production",
    	:storage => :s3,
    	:s3_region => 'us-east-1',
        :s3_permissions => "private"

    validates_attachment :package, 
        :content_type => { 
            :content_type => [
                "application/zip"
            ]
        },
        :size => { 
            :in => 0..262144.kilobytes
        }   

    #----------------S3 Direct Upload----------------
    # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
    def direct_upload_url=(escaped_url)
        write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
    end

    # Final upload processing step
    def transfer_and_cleanup
        direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(self.direct_upload_url)
        s3 = AWS::S3.new
        self.package = URI.parse(URI.escape(self.direct_upload_url))
        self.processed = true
        self.save
        s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
    end 

    # Make a uuid filename for the file
    Paperclip.interpolates :uuid_reward_upload_filename do |attachment, style|
        attachment.instance.reward_upload_uuid_to_filename
    end

    def reward_upload_uuid_to_filename
        "#{self.uuid}"
    end    

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while RewardUpload.find_by_uuid(self.uuid).present?
    end

    # Set attachment attributes from the direct upload
    # @note Retry logic handles S3 "eventual consistency" lag.
    def set_upload_attributes
        tries ||= 5
        direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
        s3 = AWS::S3.new
        direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head

        self.package_file_name     = direct_upload_url_data[:filename]
        self.package_file_size     = direct_upload_head.content_length
        self.package_content_type  = direct_upload_head.content_type
        self.package_updated_at    = direct_upload_head.last_modified
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
