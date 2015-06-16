class PatronVideosController < ApplicationController

	protect_from_forgery :except => [:upload_patron_video]

	def upload_patron_video
		patron_video = PatronVideo.create
		patron_video.user_id = params[:id]
		patron_video.save
        @video = Video.new(params[:video])
        @video.patron_video_id = patron_video.id
        @video.user_id = params[:id]
        @video.save	
		#Redirect		
	end

	def pending_patron_videos
		respond_to do |format|
    		format.html
    		format.json { render json: PendingPatronVideosDatatable.new(view_context) }
  		end				
	end	

	def patron_videos_review
		@patron_video = PatronVideo.find(params[:id])
	end

	def patron_videos_update
		@patron_video = PatronVideo.find(params[:id])
		if @patron_video.update_attributes(params[:patron_video]) then
			if @patron_video.deleted == true then
				@patron_video.update_column(:deleted_at, Time.now)
				#Delete the video
				@patron_video.video.destroy
				flash[:success] = "Patron video destroyed."
				redirect_to admin_patron_video_path
			else
				if @patron_video.status == "Approved" then
					@current_video = @patron_video.video
					#link previous video to this patron video as a record
					@user = @patron_video.user 
					@previous_video = @user.video
					@previous_video.subscribed_id = nil
					@previous_video.patron_video_id = @patron_video.id
					@previous_video.save
					#link current video to the user
					@current_video.subscribed_id = @user.id
					@current_video.patron_video_id = nil 
					@current_video.save
					#email the user about the video update
					PatronVideoReviewMailer.patron_video_review(@patron_video.id).deliver
					flash[:success] = "Patron video approved."
					redirect_to admin_patron_video_path				
				else
					if @patron_video.status == "Disapproved" then 
						@patron_video.video.destroy
						PatronVideoReviewMailer.patron_video_review(@patron_video.id).deliver
						flash[:success] = "Patron video disapproved."
						redirect_to admin_patron_video_path
					end
				end
			end
		else
			flash[:error] = "Patron video review didn't update."
			redirect_to(:back)
		end
	end

end