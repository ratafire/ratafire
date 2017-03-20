require 'elasticsearch/model'

class Campaign < ActiveRecord::Base

    # Required dependency for ActiveModel::Errors
    extend ActiveModel::Naming

    #----------------Utilities----------------

    #Environment-specific direct upload url verifier screens for malicious posted upload locations.
    DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

    #Default scope
    default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create    

    #---------ActsasTaggable--------
    acts_as_taggable_on :tags, :categories, :sub_categories

    #--------Track activities--------
    include PublicActivity::Model
    tracked except: [:update, :destroy], 
            owner: ->(controller, model) { controller && controller.current_user }           

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user

    #Has one
    has_one :video, 
        -> { where(videos:{:deleted => nil})},
        class_name:"Video",dependent: :destroy
    has_one :shipping_anywhere, class_name: "ShippingAnywhere", dependent: :destroy

    #Has many
    has_many :artwork, foreign_key: "majorpost_uuid", primary_key: 'uuid', class_name:"Artwork", dependent: :destroy
    has_many :rewards, class_name: "Reward", dependent: :destroy
    accepts_nested_attributes_for :rewards
    has_many :shippings, class_name: "Shipping", dependent: :destroy
    has_many :majorposts
    has_many :liked_campaigns
    has_many :likers, through: :liked_campaigns, source: :user
    has_many :subscriptions, 
        -> { where( subscriptions: { :real_deleted => nil}) },
        class_name: "Subscription", 
        dependent: :destroy
    has_many :subscribers, 
        -> { where( subscriptions: { :real_deleted => nil}) },
        through: :subscriptions, 
        source: :subscriber

    #----------------Versioning----------------   

    #has_paper_trail :if => Proc.new { |t| t.status == "Approved" }

    #----------------Translation----------------

    translates :title, :description#, :versioning => :paper_trail

    #--------Elastic Search--------
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    #----------------Validations----------------

    #Basic info
    validates :title, :presence => true, length: { in: 1..50 }
    #uuid
    validates_uniqueness_of :uuid, case_sensitive: false

    #----------------Attachment----------------

    #image
    has_attached_file :image, 
        :styles => { 
            :preview800 => ["800", :jpg], 
            :preview512 => ["512", :jpg],
            :preview256 => ["256", :jpg], 
            :thumbnail800 => ["800x450#",:jpg],
            :thumbnail480p => ["640x360#",:jpg],
            :thumbnail512 => ["512x512#",:jpg],
            :thumbnail128 => ["128x128#",:jpg],
            :thumbnail64 => ["64x64#",:jpg], 
            :thumbnail40 => ["40x40#",:jpg]
        }, 
        :default_url => lambda { |av| "/assets/default/audio/audio#{av.instance.default_image_number}_:style.jpg" },
        :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
        :url =>  "/:class/uploads/:id/image/:style/:uuid_campaign_filename",
        #If s3
        :path => "/:class/uploads/:id/image/:style/:uuid_campaign_filename",
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
    Paperclip.interpolates :uuid_campaign_filename do |attachment, style|
        attachment.instance.campaign_uuid_to_filename
    end

    def campaign_uuid_to_filename
        "#{self.uuid}"
    end

    def default_image_number
        user.id.to_s.last
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

    # Set attachment attributes from the direct upload
    # @note Retry logic handles S3 "eventual consistency" lag.
    def set_upload_attributes
        tries ||= 5
        direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
        s3 = AWS::S3.new
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

    #----------------Error messages----------------

    def validate_status!
        campaign_status = true
        #Check if cover image presents
        unless self.image.present?
            errors.add(:image, I18n.t('views.campaign.error_project_image'))
            campaign_status = false
        end
        user = User.find(self.user_id)
        #Check if user profile photo presents
        unless user.profilephoto.image.present?
            errors.add(:profilephoto, I18n.t('views.campaign.error_user_profile_photo'))
            campaign_status = false
        end
        #Check if user verification presents
        unless user.identity_verification
            errors.add(:profilephoto, I18n.t('views.campaign.error_user_identity_verification'))
            campaign_status = false
        end
        #Check if user bank account presents
        unless user.bank_account
            errors.add(:profilephoto, I18n.t('views.campaign.error_user_bank_account'))
            campaign_status = false
        end
        #Check if user has tagline
        unless user.tagline
            errors.add(:profilephoto, I18n.t('views.campaign.error_user_tagline'))
            campaign_status = false
        end
        #Check if user has short bio
        unless user.bio
            errors.add(:profilephoto, I18n.t('views.campaign.error_user_bio'))
            campaign_status = false
        end
        #Check if user has a campaign pending
        user.campaigns.each do |campaign|
            if campaign.status == "Pending"
                errors.add(:profilephoto, I18n.t('views.campaign.you_have_a_pending_campaign'))
                campaign_status = false
                break
            end
        end
        if campaign_status == false
            return false
        else
            return true
        end
    end



private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Campaign.find_by_uuid(self.uuid).present?
    end

end
