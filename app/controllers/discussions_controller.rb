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

	def update
		@discussion = Discussion.find(params[:id])
		@discussion.excerpt = Sanitize.clean(@discussion.content)
			if @discussion.update_attributes(params[:discussion]) then
				#1 step, update realm
				if @discussion.realm != nil && @discussion.sub_realm == nil then
					#activity tags and realms
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@discussion.id,'Discussion')
					if @activity != nil then
						@activity.realm = @discussion.realm
						@activity.save
					end							
					redirect_to discussion_subrealm_path(@discussion)
				else
					if @discussion.realm != nil && @discussion.sub_realm != nil then
						if @discussion.published == true then
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
							redirect_to show_discussion_path(@discussion)								
						else
							redirect_to discussion_edit_path(@discussion)
						end
					else
						redirect_to(:back)
					end	
				end
			end
	end

	def edit
		if user_signed_in? then
			@discussion = Discussion.find(params[:id])
			if current_user == @discussion.creator || current_user.admin == true
				if @discussion.realm == nil && @discussion.sub_realm == nil then
					redirect_to discussion_realms_path(@discussion)
				else
					if @discussion.realm != nil && @discussion.sub_realm == nil then
						redirect_to discussion_subrealm_path(@discussion)
					end

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



end