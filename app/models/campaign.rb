class Campaign < ActiveRecord::Base

    # Required dependency for ActiveModel::Errors
    extend ActiveModel::Naming

    #----------------Utilities----------------

    #Default scope
    default_scope  { order(:created_at => :desc) }

    #Generate uuid
    before_validation :generate_uuid!, :on => :create    

    #---------ActsasTaggable--------
    acts_as_taggable

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user

    #Has one
    has_many :artwork, foreign_key: "majorpost_uuid", primary_key: 'uuid', class_name:"Artwork", dependent: :destroy
    has_one :video, class_name:"Video",dependent: :destroy

    #Has many
    has_many :rewards, class_name: "Reward", dependent: :destroy
    accepts_nested_attributes_for :rewards
    has_many :shippings, class_name: "Shippings", dependent: :destroy
    has_one :shipping_anywhere, class_name: "ShippingAnywhere", dependent: :destroy

    #----------------Translation----------------

    translates :title, :description

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
            :thumbnail512 => ["512x512#",:jpg],
            :thumbnail128 => ["128x128#",:jpg],
            :thumbnail64 => ["64x64#",:jpg], 
        }, 
        :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
        :url =>  "/:class/uploads/:id/image/:style/:uuid_campaign_filename",
        #If s3
        :path => "/:class/uploads/:id/image/:style/:uuid_campaign_filename",
        :bucket => "Ratafire_production",
        :storage => :s3,
        :s3_region => 'us-east-1'

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

    #----------------Error messages----------------

    def initialize
        @errors = ActiveModel::Errors.new(self)
    end

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
