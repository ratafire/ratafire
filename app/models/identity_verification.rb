class IdentityVerification < ActiveRecord::Base
	#----------------Utilities----------------

	#--------Encryption--------
	attr_encrypted :ssn, key: ENV['SSN_KEY']
    attr_encrypted :id_card, key: ENV['ID_CARD_KEY']
    attr_encrypted :passport, key: ENV['PASSPORT_KEY']

    #Generate uuid
    before_validation :generate_uuid!, :on => :create	

    #----------------Relationships----------------
    #Belongs to
    belongs_to :user

    #----------------Attachment----------------

    #--- Artwork Attachment ---
    has_attached_file :identity_document, 
        :styles => { 
            :preview1280 => ["1280", :jpg],
            :preview800 => ["800", :jpg], 
            :preview512 => ["512", :jpg],
            :preview256 => ["256", :jpg], 
            :thumbnail512 => ["512x512#",:jpg],
            :thumbnail128 => ["128x128#",:jpg],
            :thumbnail64 => ["64x64#",:jpg], 
        }, 
        :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
        :url =>  "/:class/uploads/:id/:style/:uuid_filename",
        #If s3
        :path => "/:class/uploads/:id/:style/:uuid_filename",
        :bucket => "Ratafire_production",
        :storage => :s3,
        :s3_region => 'us-east-1'

        validates_attachment :identity_document, 
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

    # Make a uuid filename for the file
    Paperclip.interpolates :uuid_filename do |attachment, style|
        attachment.instance.identity_verification_uuid_to_filename
    end

    def identity_verification_uuid_to_filename
        "#{self.uuid}"
    end

private

    def generate_uuid!
        begin
            self.uuid = SecureRandom.hex(16)
        end while IdentityVerification.find_by_uuid(self.uuid).present?
    end

end
