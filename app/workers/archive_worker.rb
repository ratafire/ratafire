class ArchiveWorker
	@queue = :archive_queue
	#could be retrying all the time, this has to be thread save

	def self.perform(project_id)
		@project = Project.find(project_id)

		#save the project archive begin -----------------
			archive = Archive.create
			archive.title = @project.title
			archive.content = @project.about
			archive.tag_list = @project.tag_list
			archive.project_id = @project.id
			archive.user_id = @project.creator.id
			archive.created_time = @project.created_at
			#If the project has video
			if @project.video_id != nil && @project.video_id != "" then
				video = Video.find(@project.video_id)
				if video.encoded_state == "finished" then
					archive_video = Video.new
					archive_video.skip_everafter = true
					archive_video.archive_id = archive.id
					archive_video.project_id = @project.id
					archive_video.output_url = video.output_url
					archive_video.user_id = video.user_id
					archive_video.encoded_state = "finished"
					archive_video.direct_upload_url = video.direct_upload_url
					archive_video.video = video.video
					archive_video.thumbnail = video.thumbnail
					archive_video.save
				end
			end
			#If the project has artwork
			if @project.artwork_id != nil && @project.artwork_id != "" then
				artwork = Artwork.find(@project.artwork_id)
				archive_artwork = Artwork.new
				archive_artwork.skip_everafter = true
				archive_artwork.project_id = @project.id
				archive_artwork.archive_id = archive.id
				archive_artwork.direct_upload_url = artwork.direct_upload_url
				archive_artwork.user_id = artwork.user_id
				archive_artwork.image = artwork.image
				archive_artwork.save
			end
			#If the project has icon
			if @project.icon_id != nil && @project.icon_id != "" then
				icon = Icon.find(@project.icon_id)
				archive_icon = Icon.new
				archive_icon.skip_everafter = true
				archive_icon.project_id = @project.id
				archive_icon.archive_id = archive.id
				archive_icon.direct_upload_url = icon.direct_upload_url
				archive_icon.user_id = icon.user_id
				archive_icon.image = icon.image
				archive_icon.save
			end	
			#If the project has audio
			if @project.audio_id != nil && @project.audio_id != "" then
				audio = Audio.find(@project.audio_id)
				archive_audio = Audio.new
				archive_audio.skip_everafter = true
				archive_audio.project_id = @project.id
				archive_audio.archive_id = archive.id
				archive_audio.direct_upload_url = audio.direct_upload_url
				archive_audio.user_id = audio.user_id
				archive_audio.audio = audio.audio
				archive_audio.save
			end
			#If the project has pdf
			if @project.pdf_id != nil && @project.pdf_id != "" then
				pdf = Pdf.find(@project.pdf_id)
				archive_pdf = Pdf.new
				archive_pdf.skip_everafter = true
				archive_pdf.project_id = @project.id
				archive_pdf.archive_id = archive.id
				archive_pdf.direct_upload_url = pdf.direct_upload_url
				archive_pdf.user_id = pdf.user_id
				archive_pdf.pdf = pdf.pdf
				archive_pdf.save
			end			
			#If the project has images
			if @project.projectimages.count != 0 then
				@project.projectimages.each do |i|
					archiveimage = Archiveimage.new
					archiveimage.archive_id = archive.id
					archiveimage.url = i.url
					archiveimage.thumbnail = i.thumbnail
					archiveimage.save
				end
			end
			#save the archive for project
			archive.save

		#save the project archive end -----------------
			
		#start archiving the majorposts		
		@project.majorposts.where(:published => true).each do |majorpost|

		#save the project archive begin -----------------	
			archive = Archive.create
			archive.title = majorpost.title
			archive.content = majorpost.content
			archive.tag_list = majorpost.tag_list
			archive.majorpost_id = majorpost.id
			archive.project_id = @project.id
			archive.user_id = majorpost.user.id
			archive.created_time = majorpost.created_at
			#If the majorpost has video
			if majorpost.video_id != nil && majorpost.video_id != "" then
				video = Video.find(majorpost.video_id)
				archive_video = Video.new
				archive_video.skip_everafter = true
				archive_video.direct_upload_url = video.direct_upload_url
				archive_video.user_id = video.user_id
				archive_video.archive_id = archive.id
				archive_video.project_id = @project.id
				archive_video.majorpost_id = majorpost.id
				#If external video 
				if video.external != nil && video.external != "" then
					archive_video.external = video.external
					archive_video.youtube_vimeo = video.youtube_vimeo
					archive_video.archive_id = archive.id
					archive_video.save
				else
					#It is an internal video
					if video.encoded_state == "finished" then
						archive_video.video = video.video
						archive_video.encoded_state = "finished"
						archive_video.output_url = video.output_url
						archive_video.thumbnail = video.thumbnail
						archive_video.save
					end
				end
			end	
			#If the majorpost has artwork
			if majorpost.artwork_id != nil && majorpost.artwork_id != "" then
				artwork = Artwork.find(majorpost.artwork_id)
				archive_artwork = Artwork.new
				archive_artwork.skip_everafter = true
				archive_artwork.majorpost_id = majorpost.id
				archive_artwork.project_id = @project.id
				archive_artwork.archive_id = archive.id
				archive_artwork.direct_upload_url = artwork.direct_upload_url
				archive_artwork.user_id = artwork.user_id
				archive_artwork.image = artwork.image
				archive_artwork.save	#AWS::S3::Errors::RequestTimeout bug!				
			end

			#If the project has audio
			if majorpost.audio_id != nil && majorpost.audio_id != "" then
				audio = Audio.find(majorpost.audio_id)
				archive_audio = Audio.new
				archive_audio.skip_everafter = true
				archive_audio.majorpost_id = majorpost.id
				archive_audio.project_id = @project.id
				archive_audio.archive_id = archive.id
				archive_audio.direct_upload_url = audio.direct_upload_url
				archive_audio.user_id = audio.user_id
				archive_audio.audio = audio.audio
				archive_audio.save
			end

			#If the project has pdf
			if majorpost.pdf_id != nil && majorpost.pdf_id != "" then
				pdf = Pdf.find(majorpost.pdf_id)
				archive_pdf = Pdf.new
				archive_pdf.skip_everafter = true
				archive_pdf.majorpost_id = majorpost.id
				archive_pdf.project_id = @project.id
				archive_pdf.archive_id = archive.id
				archive_pdf.direct_upload_url = pdf.direct_upload_url
				archive_pdf.user_id = pdf.user_id
				archive_pdf.pdf = pdf.pdf
				archive_pdf.save
			end			
			#If the majorpost has images
			if majorpost.postimages.count != 0 then
				majorpost.postimages.each do |i|
					archiveimage = Archiveimage.new
					archiveimage.archive_id = archive.id
					archiveimage.url = i.url
					archiveimage.thumbnail = i.thumbnail
					archiveimage.save
				end
			end				
			 
			#save the archive for majorpost
			archive.save
		#save the project archive end -----------------	

			if majorpost.edit_permission == "free" then
				majorpost.edit_permission = "edit"
				majorpost.save
			end
		end
		@project.edit_permission = "edit"
		@project.save
	end

end