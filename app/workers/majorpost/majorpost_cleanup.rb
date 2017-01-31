class Majorpost::MajorpostCleanup
	#delete artwork, link, audio, video after a majorpost is deleted
	@queue = :majorpost
	def self.perform(majorpost_uuid)
		#Delete artwork
		Artwork.where(majorpost_uuid: majorpost_uuid).all.each do |artwork|
			artwork.destroy
		end 
		#Delete link
		Link.where(majorpost_uuid: majorpost_uuid).all.each do |link|
			link.destroy
		end
		#Delete audio
		Audio.where(majorpost_uuid: majorpost_uuid).all.each do |audio|
			audio.destroy
		end		
		#Delete video
		Video.where(majorpost_uuid: majorpost_uuid).all.each do |video|
			video.destroy
		end	
	end 
end