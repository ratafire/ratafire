class DiscussionsController < ApplicationController

	layout 'application'


	def create
		@discussion = Discussion.prefill!(:user_id => current_user.id)
		#AssignedDiscussion
		@assigneddiscussion = AssignedDiscussion.new()
		@assigneddiscussion.user_id = current_user.id
		@assigneddiscussion.discussion_id = @discussion.id
		@assigneddiscussion.save
		if @discussion != nil then 
			redirect_to discussion_realms_path(@discussion)
		else
			redirect_to(:back)
		end
	end

	#Step 1
	def realm
		@discussion = Discussion.find(params[:id])
	end

	#Step 2
	def subrealm
		@discussion = Discussion.find(params[:id])
	end

	def update_title_and_tagline
		@discussion = Discussion.find(params[:id])
		respond_to do |format|
			if @discussion.update_attributes(params[:discussion]) then
				format.json { respond_with_bip(@discussion) }
			else
				format.json { respond_with_bip(@discussion) }
			end
		end
	end

	def update
		@discussion = Discussion.find(params[:id])
		@discussion.excerpt = Sanitize.clean(@discussion.content)
		if @discussion.update_attributes(params[:discussion]) then
			#If Pending
			if @discussion.review_status == "Pending" then 
				@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@discussion.id,'Discussion')
				if @activity != nil then
					@activity.sub_realm = @discussion.sub_realm
					@activity.tag_list = @discussion.tag_list
					@activity.commented_at = Time.now
					@activity.status = "Pending"
					@activity.save
				end	
			else
				if @discussion.review_status == "Disapproved" then
					@discussion.review_status = "Pending"
					@discussion.reviewed_at = nil
					@discussion.save
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@discussion.id,'Discussion')
					if @activity != nil then
						@activity.sub_realm = @discussion.sub_realm
						@activity.tag_list = @discussion.tag_list
						@activity.status = "Pending"
						@activity.save
					end	
				else
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@discussion.id,'Discussion')
					if @activity != nil then
						@activity.tag_list = @discussion.tag_list
						@activity.status = @discussion.status
						@activity.commented_at = @discussion.commented_at
						@activity.save
					end	
				end
			end				
			if @discussion.published == true then
				if title_parser(@discussion.title) == true then
					if @discussion.sub_realm != nil then
						if @discussion.content != nil || @discussion.content != "" then
							if @discussion.tags.any?
								@discussion.published_at = Time.now
								@discussion.save
								flash["success"] = 'Your discussion is under review.'
								redirect_to show_discussion_path(@discussion)	
							else
								@discussion.published = false
								@discussion.save
								flash["error"] = 'Please add several tags for this discussion.'
								redirect_to discussion_edit_path(@discussion)								
							end						
						else
							@discussion.published = false
							@discussion.save
							flash["error"] = 'Please enter the content of this discussion.'
							redirect_to discussion_edit_path(@discussion)	
						end
					else
						@discussion.published = false
						@discussion.save
						flash["error"] = 'Please select a field for this discussion.'
						redirect_to discussion_edit_path(@discussion)						
					end
				else
					@discussion.published = false
					@discussion.save
					flash["error"] = 'Please enter a title for this discussion.'
					redirect_to discussion_edit_path(@discussion)
				end
			else
				
			end		
		end
	end

	def edit
		if user_signed_in? then
			@discussion = Discussion.find(params[:id])
			if current_user == @discussion.creator || current_user.admin == true
				if @discussion.realm == nil then
					redirect_to discussion_realms_path(@discussion)
				end
			end	
		else
			redirect_to root_path
		end
	end

	def destroy
		@discussion = Discussion.find(params[:id])
		@user = @discussion.creator
		#Set Activities of the Discussion as deleted
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@discussion.id,'Discussion')
		if @activity != nil then
			@activity.deleted = true
			@activity.deleted_at = Time.now
			@activity.save
		end
		#Set Discussion as deleted
		@discussion.deleted = true
		@discussion.deleted_at = Time.now
		@discussion.save
		flash[:success] = "Discussion thrown away, and you hit a pine nut."
		redirect_to user_path(@user)		
	end	

	def show
		@discussion = Discussion.find(params[:id])
		if @discussion.published == false then
			redirect_to discussion_edit_path(@discussion.id)
		end
		@discussion_thread = DiscussionThread.new()
		@discussion_threads = @discussion.discussion_threads.paginate(page: params[:page], :per_page => 30)
		@level_1_threads = @discussion.discussion_threads.where(:level => 1).paginate(page: params[:page], :per_page => 30)
	end

private

	def title_parser(title)
		title_s = title.split(" ")
		if title_s[0] == "Click" && title_s[1] == "to" && title_s[2] == "enter" && title_s[3] == "a" && title_s[4] == "title" then
			return false
		else
			return true
		end
	end

end