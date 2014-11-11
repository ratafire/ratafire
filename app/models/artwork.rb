class Artwork < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :majorpost_id, :name, :image, :project_id, :content_temp, :tags_temp, :direct_upload_url,:skip_everafter
  belongs_to :majorpost
  belongs_to :project
  belongs_to :archive

  #Environment-specific direct upload url verifier screens for malicious posted upload locations.
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  before_create :set_upload_attributes, :unless => :skip_everafter
  after_create :queue_processing, :unless => :skip_everafter

  #--- Artwork Attachment ---
  has_attached_file :image, 
  					:styles => { :preview => ["790", :jpg], :small => ["64x64#", :jpg], :thumbnail => ["171x96#",:jpg] }, :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
  :url =>  "/:class/uploads/:id/:style/:escaped_filename",
  #If s3
  :path => "/:class/uploads/:id/:style/:escaped_filename",
  :storage => :s3

  validates_attachment :image, 
    :content_type => { :content_type => ["image/jpeg","image/jpg","image/png","image/psd","image/vnd.adobe.photoshop","image/bmp"]},
    :size => { :in => 0..524288.kilobytes}

  #process_in_background :image, :only_process => [:small, :thumbnail]  

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  # Determines if file requires post-processing (image resizing, etc)
  def post_process_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|psd|jpg|pjpeg|png|x-png)$}.match(image_content_type).present?
  end  

  Paperclip.interpolates :escaped_filename do |attachment, style|
    attachment.instance.normalized_video_file_name
  end

  def normalized_video_file_name
    "#{self.id}-#{self.image_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
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
    Resque.enqueue(ArtworkUploadWorker,self.id)
  end

end
