class VideoUploadWorker

	@queue = :video_upload_queue

  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/Ratafire_#{Rails.env}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

	def self.perform(id)
    	video = Video.find(id)
    	direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(video.direct_upload_url)
    	s3 = AWS::S3.new
    
    	if video.post_process_required?
      		video.video = URI.parse(URI.escape(video.direct_upload_url))
    	else
      		paperclip_file_path = "videos/uploads/#{id}/original/#{direct_upload_url_data[:filename]}"
      		s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])
    	end
 
    	video.processed = true
    	video.save
    
    	s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete

	end

end	