class Image::ArtworkMajorpostCleanup
	#if there is an artwork that is save, but not in the majorpost's content, delete it!
	@queue = :image 
	def self.perform(majorpost_uuid)
		if @majorpost = Majorpost.find_by_uuid(majorpost_uuid) then
			#Parse the content
			content = Nokogiri::HTML(@majorpost.content)
			post_images ||= Array.new
			post_images = content.css('img').map{ |i| i['src'] }
			@post_images ||= Array.new
			Array(post_images).each do |p|
				image_uuid = p.split("/").last
				@post_image.push(image_uuid)
			end
			Array(Artwork.find_by_majorpost_uuid(majorpost_uuid)).each do |artwork|
				unless @post_image.index(artwork.uuid)
					artwork.destroy
				end
			end 
		end
	end 
end