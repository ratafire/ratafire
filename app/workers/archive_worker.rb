class ArchiveWorker
	@queue = :archive_queue
	#could be retrying all the time, this has to be thread save

	def self.perform(project_id)
		@project = Project.find(project_id)
		#save the project archive
		self.project_archiver
		#start archiving the majorposts		
		@project.majorposts.where(:published => true).each do |majorpost|
			self.majorpost_archiver(majorpost)
			if majorpost.edit_permission == "free" then
				majorpost.edit_permission = "edit"
				majorpost.save
			end
		end
		@project.edit_permission = "edit"
		@project.save
	end

private

		#Project archive maker
		def self.project_archiver 
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
					archive_video = Video.create
					archive_video.archive_id = archive.id
					archive_video.project_id = @project.id
					archive_video.output_url = video.output_url
					archive_video.encoded_state = "finished"
					archive_video.video = video.video
					archive_video.thumbnail = video.thumbnail
					archive_video.save
				end
			end
			#If the project has artwork
			if @project.artwork_id != nil && @project.artwork_id != "" then
				artwork = Artwork.find(@project.artwork_id)
				archive_artwork = Artwork.create
				archive_artwork.project_id = @project.id
				archive_artwork.archive_id = archive.id
				archive_artwork.image = artwork.image
				archive_artwork.save
			end
			#If the project has icon
			if @project.icon_id != nil && @project.icon_id != "" then
				icon = Icon.find(@project.icon_id)
				archive_icon = Icon.create
				archive_icon.project_id = @project.id
				archive_icon.archive_id = archive.id
				archive_icon.image = icon.image
				archive_icon.save
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
		end

		#Majorpost archive maker
		def self.majorpost_archiver(majorpost)
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
				archive_video = Video.create
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
				archive_artwork = Artwork.create
				archive_artwork.majorpost_id = majorpost.id
				archive_artwork.project_id = @project.id
				archive_artwork.archive_id = archive.id
				archive_artwork.image = artwork.image
				archive_artwork.save	#AWS::S3::Errors::RequestTimeout bug!				
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
		end


end