class Majorpost::MajorpostCleanup
	#delete artwork, link, audio, video after a majorpost is deleted
	@queue = :majorpost
	def self.perform(majorpost_uuid)
		time = Time.now
		#Delete artwork
		Array(Artwork.find_by_majorpost_uuid(majorpost_uuid)).each do |artwork|
			artwork.update(
				deleted: true,
				deleted_at: time
				)
		end 
		#Delete link
		Array(Link.find_by_majorpost_uuid(majorpost_uuid)).each do |link|
			link.update(
				deleted: true,
				deleted_at: time
				)
		end
		#Delete audio
		Array(Audio.find_by_majorpost_uuid(majorpost_uuid)).each do |audio|
			audio.update(
				deleted: true,
				deleted_at: time
				)
		end		
		#Delete video
		Array(Video.find_by_majorpost_uuid(majorpost_uuid)).each do |video|
			video.update(
				deleted: true,
				deleted_at: time
				)
		end	
	end 
end