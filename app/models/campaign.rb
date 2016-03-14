class Campaign < ActiveRecord::Base

    #----------------Utilities----------------

    #Generate uuid
    before_validation :generate_uuid!, :on => :create    

    #---------ActsasTaggable--------
    acts_as_taggable

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user

    #Has one
    has_one :artwork, class_name:"Artwork", dependent: :destroy
    has_one :video, class_name:"Video",dependent: :destroy

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

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while Campaign.find_by_uuid(self.uuid).present?
    end

end
