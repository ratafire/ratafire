class FacebookPage < ActiveRecord::Base
    #----------------Utilities----------------
    #Generate uuid
    before_validation :generate_uuid!, :on => :create    
    #--------Friendlyid--------
    extend FriendlyId
    friendly_id :uuid
    #---------ActsasTaggable--------
    acts_as_taggable
    #----------------Relationships----------------
    #Belongs to
    belongs_to :user
    belongs_to :facebook
    #Has one
    has_one :facebookpage

    #----------------Attachment----------------

    #--- Artwork Attachment ---
	has_attached_file :facebookprofile, :styles => {
            :thumbnail512 => ["512x512#",:jpg],
            :thumbnail256 => ["256x256#",:jpg],
            :thumbnail128 => ["128x128#",:jpg],
            :thumbnail64 => ["64x64#",:jpg], 
    },
	:default_url => "/assets/projecticon_:style.jpg",
	:url =>  "/:class/uploads/:id/:style/:escaped_filename2",
    #If s3
    :path => "/:class/uploads/:id/:style/:escaped_filename2",
    :storage => :s3,
    :s3_region => 'us-east-1',
    :s3_credentials => "#{Rails.root}/config/s3_profile.yml"

    validates_attachment :facebookprofile, 
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
	Paperclip.interpolates :escaped_filename2 do |attachment, style|
		attachment.instance.normalized_profile_file_name
	end    

	def normalized_profile_file_name
		"#{self.id}-#{self.facebookprofile_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
	end	

    #Save image from url
    def image_from_url(url)
        self.facebookprofile = open(url)
    end

protected
	
	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while FacebookPage.find_by_uuid(self.uuid).present?
	end
end