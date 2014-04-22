class Icon < ActiveRecord::Base
	attr_accessible :image, :project_id, :content_temp, :tags_temp, :archive_id, :direct_upload_url	
   #Project Icon
   belongs_to :project
   belongs_to :archive

  #Environment-specific direct upload url verifier screens for malicious posted upload locations.
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire#{!Rails.env.production? ? "\\_#{Rails.env}" : ''}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  before_create :set_upload_attributes
  after_create :queue_processing

  has_attached_file :image, :styles => { :pageview => "128x128#", :small => "40x40#"}, 
  							:default_url => "/assets/projecticon_:style.jpg",
      :url =>  "/:class/uploads/:id/:style/:escaped_filename",
      #If s3
      :path => "/:class/uploads/:id/:style/:escaped_filename",
      :storage => :s3

  default_scope order: 'icons.created_at DESC'      

  #process_in_background :image, :only_process => [:small]    

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  # Determines if file requires post-processing (image resizing, etc)
  def post_process_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|psd|jpg|pjpeg|png|x-png)$}.match(image_content_type).present?
  end  

  validates_attachment :image, 
    :content_type => { :content_type => ["image/jpeg","image/jpg","image/png"]},
    :size => { :in => 0..10240.kilobytes}

  Paperclip.interpolates :escaped_filename do |attachment, style|
    attachment.instance.normalized_video_file_name
  end

  def normalized_video_file_name
    "#{self.id}-#{self.image_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end

  # Final upload processing step
  def self.transfer_and_cleanup(id)
    icon = Icon.find(id)
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(icon.direct_upload_url)
    s3 = AWS::S3.new
    
    if icon.post_process_required?
      icon.image = URI.parse(URI.escape(icon.direct_upload_url))
    else
      paperclip_file_path = "icons/uploads/#{id}/original/#{direct_upload_url_data[:filename]}"
      s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])
    end
 
    icon.processed = true
    icon.save
    
    s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
  end  

protected

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

  # Queue file processing
  def queue_processing
    Icon.transfer_and_cleanup(id)
  end


end
