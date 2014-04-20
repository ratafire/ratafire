class ArchivesController < ApplicationController

	#This is for the completion of project!
	def complete
		@project = Project.find(params[:id])
		@project.completion_time = Time.now
		@project.edit_permission = "freeze"
		@project.complete = true
		@project.save
		redirect_to(:back)
		Resque.enqueue(ArchiveWorker,@project.id)
	end


	def show
		@archive = Archive.find(params[:id])
		@project = Project.find(params[:project_id])
		#Majorpost
		if @archive.majorpost_id != nil then
			@majorpost = @archive.majorpost
		end
		@majorpost_count = @project.majorposts.where(:published => true).count
		if @archive.artwork != nil then
			@artwork = @archive.artwork
		end 
		#Video
		if @archive.video != nil then
			@video = @archive.video
		end
		#Icon
		if @project.icon_id != "" && @project_icon_id != nil then
			@icon = Icon.find(@project.icon_id)
		end
		#bifrosts
		@bifrost = Bifrost.new(params[:bifrost])
		@bifrost.connections.build(params[:connection])	
	end

	def about_show
		@archive = Archive.find(params[:id])
		@project = Project.find(params[:project_id])
		#majorpost
		@majorpost_count = @project.majorposts.where(:published => true).count
		if @archive.artwork != nil then
			@artwork = @archive.artwork
		end
		#Video
		if @archive.video != nil then
			@video = @archive.video
		end
		#Icon
		if @project.icon_id != "" && @project_icon_id != nil then
			@icon = Icon.find(@project.icon_id)
		end
		#bifrosts
		@bifrost = Bifrost.new(params[:bifrost])
		@bifrost.connections.build(params[:connection])			
	end

	def archive
		@project = Project.find(params[:id])
		@archive = @project.archives
		@archive_display = @project.archives.where(Archive.arel_table[:majorpost_id].not_eq(nil)).paginate(page: params[:post], :per_page => 20)
		@project_archive = @project.archives[0]
		@majorpost_count = @project.majorposts.where(:published => true).count
		@archive_count = @project.archives.count - 1 #because one of the archives are for the project itself
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end
	end

	def videos
		@project = Project.find(params[:id])
		@archive = @project.archives
		@project_archive = @project.archives[0]
		video ||= Array.new
		@project.archives.each do |a|
			if a.video != nil then
				video.push(a.video)
			end
		end
		@video = video.paginate(page: params[:video], :per_page => 18)	
		@majorpost_count = @project.majorposts.where(:published => true).count
		@archive_count = @project.archives.count - 1
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end		
	end

	def artwork
		@project = Project.find(params[:id])
		@archive = @project.archives
		@project_archive = @project.archives[0]
		artwork ||= Array.new
		@project.archives.each do |a|
			if a.artwork != nil then
				artwork.push(a.artwork)
			end
		end
		@artwork = artwork.paginate(page: params[:artwork], :per_page => 18)
		@majorpost_count = @project.majorposts.where(:published => true).count
		@archive_count = @project.archives.count - 1
		#Icon
		if @project.icon_id != "" && @project.icon_id != nil then
			@icon = Icon.find(@project.icon_id)	
		end				
	end

	def chapter
		@archive = Archive.find(params[:id])
		@project = Project.find(params[:project_id])
	end

#Deep copy of video if needed

				#If external video 
#				if video.external != nil && video.external != "" then
#					archive_video.external = video.external
#					archive_video.youtube_vimeo = video.youtube_vimeo
#					archive_video.project_id = @project.id
#					archive_video.archive_id = archive.id
#					archive.save
#				else
#					#It is an internal video
#					if video.encoded_state == "finished" then
#						splited = video.output_url.split("/")
#						key = splited[4]
#						#copy file on S3
#						s3 = AWS::S3.new(
#        					:access_key_id     => zencoder_setting["s3_output"]["access_key_id"],
#        					:secret_access_key => zencoder_setting["s3_output"]["secret_access_key"]
#      					)
#						bucket = s3.buckets[zencoder_setting["s3_output"]["bucket"]]
#						object = bucket.objects["#{key}"]
#						new_object = object.copy_to("archive_#{key}")
#						#save the s3 new object to archive
#						archive_video.encoded_state = "finished"
#						archive_video.output_url = new_object.key
#						archive_video.save
#					end
#				end

end	