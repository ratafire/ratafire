class Image::ArtworkCleanup
	#Clean up majorpost artwork after
	@queue = :image 
	def self.perform(majorpost_uuid)
		Array(Artwork.find_by_majorpost_uuid(majorpost_uuid)).each do |artwork|
			artwork.destroy
		end 
	end 
end