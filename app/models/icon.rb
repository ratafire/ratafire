class Icon < ActiveRecord::Base
    belongs_to :majorpost
    belongs_to :project	
  has_attached_file :image, :styles => { :pageview => "128x128#", :small => "40x40#"}, 
  							:default_url => "/assets/projecticon_:style.jpg",
      :url =>  "/:class/uploads/:id/:style/:escaped_filename",
      #If s3
      :path => "/:class/uploads/:id/:style/:escaped_filename",
      :bucket => "Ratafire_production",
      :storage => :s3,
      :s3_region => 'us-east-1'
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
end