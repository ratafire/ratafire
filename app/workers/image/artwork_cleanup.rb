class Image::ArtworkCleanup
	#Clean up majorpost artwork after
	@queue = :image 
	def self.perform(majorpost_uuid)
		Artwork.where(majorpost_uuid: majorpost_uuid).all.each do |artwork|
			artwork.destroy
		end 
	end 
end