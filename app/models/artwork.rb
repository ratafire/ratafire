class Artwork < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :majorpost_id, :name, :image, :project_id, :content_temp, :tags_temp
  belongs_to :majorpost
  belongs_to :project
  belongs_to :archive
    #--- Artwork Attachment ---
  has_attached_file :image, 
  					:styles => { :preview => ["790", :jpg], :small => ["64x64#", :jpg], :thumbnail => ["171x96#",:jpg] }, :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
  :url =>  "/:class/:id/:style/:escaped_filename",
  #If s3
  :path => "/:class/:id/:style/:escaped_filename",
  :storage => :s3, # this is redundant if you are using S3 for all your storage requirements
  :s3_credentials => "#{Rails.root}/config/s3_artwork.yml"  

  validates_attachment :image, 
    :content_type => { :content_type => ["image/jpeg","image/jpg","image/png","image/psd","image/vnd.adobe.photoshop","image/bmp"]},
    :size => { :in => 0..524288.kilobytes}

  process_in_background :image, :only_process => [:small, :thumbnail]  

  Paperclip.interpolates :escaped_filename do |attachment, style|
    attachment.instance.normalized_video_file_name
  end

  def normalized_video_file_name
    "#{self.id}-#{self.image_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end

end
