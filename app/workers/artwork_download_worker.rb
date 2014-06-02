class ArtworkDownloadWorker

	@queue = :artwork_download_queue

	def self.perform(artwork_id)
		@artwork = Artwork.find(artwork_id)
		#If not S3
		#send_file @artwork.image.path,
		#:type => @artwork.image.content_type,
		#:disposition => 'attachment', :x_sendfile => true
		#If S3
		data = open(@artwork.image.url)
 	 	send_data data.read, :type => data.content_type, :x_sendfile => true
	end

end