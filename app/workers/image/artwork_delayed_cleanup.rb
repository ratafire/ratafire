class Image::ArtworkDelayedCleanup
	#check if an artwork doesn't have a majorpost, if so delete it
	@queue = :image 
	def self.perform(artwork_uuid)
		if @artwork = Artwork.find_by_uuid(artwork_uuid) then
			unless Majorpost.find_by_uuid(@artwork.uuid) then
				@artwork.destroy
			end
		end
	end 
end