class Pdf < ActiveRecord::Base
require 'aws/s3'

  # Environment-specific direct upload url verifier screens for malicious posted upload locations.
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  RANDOM_FILENAME = SecureRandom.hex(16)

  before_create :set_upload_attributes, :unless => :skip_everafter
  after_create :queue_processing, :unless => :skip_everafter

  attr_accessible  :title, :project_id, :majorpost_id,:video, :content_temp, :tags_temp, :archive_id, :direct_upload_url, :skip_everafter
  belongs_to :majorpost
  belongs_to :project
  belongs_to :archive


  has_attached_file :pdf,  
    :styles => { :thumb => ["171x96#", :jpg], :preview => ["790x1053", :jpg]}, processors: [:ghostscript],
  	:url => ":class/uploads/:id/:style/:escaped_filename",
  	:path => ":class/uploads/:id/:style/:escaped_filename",
  	:storage => :s3 # this is redundant if you are using S3 for all your storage requirements

  validates_attachment :pdf,
    :size => { :in => 0..524288.kilobytes}  

  #process_in_background :thumbnail, :only_process => [:small, :thumbnail

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  # Determines if file requires post-processing (image resizing, etc)
  def post_process_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}.match(video_content_type).present?
  end

  Paperclip.interpolates :escaped_filename do |attachment, style|
    attachment.instance.normalized_video_file_name
  end           

  def normalized_video_file_name
    "#{self.id}-#{self.pdf_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end     

protected
  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes

      tries ||= 5
      direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
      s3 = AWS::S3.new
      direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head
 
      self.pdf_file_name     = direct_upload_url_data[:filename]
      self.pdf_file_size     = direct_upload_head.content_length
      self.pdf_content_type  = direct_upload_head.content_type
      self.pdf_updated_at    = direct_upload_head.last_modified

      
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

      pdf = Pdf.find(id)
      direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(pdf.direct_upload_url)
      s3 = AWS::S3.new

          paperclip_file_path = "pdfs/uploads/#{id}/original/#{normalized_video_file_name}"
          s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])

      pdf.pdf.reprocess!
      pdf.processed = true
      pdf.save
    
      s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
  end

end

