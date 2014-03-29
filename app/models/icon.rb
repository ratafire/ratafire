class Icon < ActiveRecord::Base
	attr_accessible :image, :project_id, :content_temp, :tags_temp, :archive_id	
   #Project Icon
   belongs_to :project
   belongs_to :archive
  has_attached_file :image, :styles => { :pageview => "128x128#", :small => "40x40#"}, 
  							:default_url => "/assets/projecticon_:style.jpg",
      :url =>  "/:class/:id/:style/:escaped_filename",
      #If s3
      :path => "/:class/:id/:style/:escaped_filename",
      :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/s3_icon.yml"  

  validates_attachment :image, 
    :content_type => { :content_type => ["image/jpeg","image/jpg","image/png"]},
    :size => { :in => 0..10240.kilobytes}

  Paperclip.interpolates :escaped_filename do |attachment, style|
    attachment.instance.normalized_video_file_name
  end

  def normalized_video_file_name
    "#{self.id}-#{self.image_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end

end
