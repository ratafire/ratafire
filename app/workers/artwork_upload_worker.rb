class ArtworkUploadWorker

	@queue = :artwork_upload_queue

  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire#{!Rails.env.production? ? "\\_#{Rails.env}" : ''}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

	def self.perform(id)
    	artwork = Artwork.find(id)
    	direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(artwork.direct_upload_url)
    	s3 = AWS::S3.new
    
    	if artwork.post_process_required?
      		artwork.image = URI.parse(URI.escape(artwork.direct_upload_url))
    	else
      		paperclip_file_path = "artworks/uploads/#{id}/original/#{artwork.image_file_name}"
      		s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])
    	end
 
    	artwork.processed = true
    	artwork.save
    
    	s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete

	end

end	