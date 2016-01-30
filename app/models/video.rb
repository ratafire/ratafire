class Video < ActiveRecord::Base

    #----------------Utilities----------------

    #----------------Relationships----------------
    #Belongs to
    belongs_to :majorpost

    #----------------Attachment----------------
    #Random Filename
    RANDOM_FILENAME = SecureRandom.hex(16)


    #--- Thumbnail Attachment ---
  	has_attached_file :thumbnail, 
        :styles => { 
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

    #Reprocess thumbnail
    def reprocess_thumbnail
        Video.all.each do |v|
            if v.thumbnail != nil then
                v.thumbnail.reprocess! 
                v.save
            end
        end
    end

end