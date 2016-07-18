class Majorpost::MajorpostCleanup
	#delete artwork, link, audio, video after a majorpost is deleted
	@queue = :majorpost
	def self.perform(majorpost_uuid)
		time = Time.now
		#Delete artwork
		Array(Artwork.find_by_majorpost_uuid(majorpost_uuid)).each do |artwork|
			artwork.destroy
		end 
		#Delete link
		Array(Link.find_by_majorpost_uuid(majorpost_uuid)).each do |link|
			link.destroy
		end
		#Delete audio
		Array(Audio.find_by_majorpost_uuid(majorpost_uuid)).each do |audio|
			audio.destroy
		end		
		#Delete video
		Array(Video.find_by_majorpost_uuid(majorpost_uuid)).each do |video|
			video.destroy
		end	
	end 
end