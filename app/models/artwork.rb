class Artwork < ActiveRecord::Base
    # attr_accessible :title, :body
    #attr_accessible :majorpost_id, :name, :image, :project_id, :content_temp, :tags_temp, :direct_upload_url,:skip_everafter
    #----------------Utilities----------------

    #Save iamge from url
    require "open-uri" 

    #----------------Relationships----------------
    #Belongs to
    belongs_to :majorpost
    belongs_to :project

    #----------------Attachment----------------

    #--- Artwork Attachment ---
    has_attached_file :image, 
        :styles => { 
            :preview800 => ["800", :jpg], 
            :preview512 => ["512", :jpg],
            :preview256 => ["256", :jpg], 
            :thumbnail512 => ["512x512#",:jpg],
            :thumbnail128 => ["128x128#",:jpg],
            :thumbnail64 => ["64x64#",:jpg], }, 
        :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
        :url =>  "/:class/uploads/:id/:style/:escaped_filename",
        #If s3
        :path => "/:class/uploads/:id/:style/:escaped_filename",
        :bucket => "Ratafire_production",
        :storage => :s3,
        :s3_region => 'us-east-1'

        validates_attachment :image, 
        :content_type => { :content_type => ["image/jpeg","image/jpg","image/png","image/bmp"]},
        :size => { :in => 0..524288.kilobytes}


    # Escape the file name
    Paperclip.interpolates :escaped_filename do |attachment, style|
        attachment.instance.normalized_video_file_name
    end

    def normalized_video_file_name
        "#{self.id}-#{self.image_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
    end

    #Save image from url
    def image_from_url(url)
        self.image = open(url)
        self.direct_upload_url = "none"
    end

protected

end
