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
			if @discussion.update_attributes(params[:discussion]) then
				#1 step, update realm
				if @discussion.realm != nil && @discussion.sub_realm == nil then
					redirect_to discussion_subrealm_path(@discussion)
				else
					if @discussion.realm != nil && @discussion.sub_realm != nil then
						redirect_to discussion_edit_path(@discussion)
					else
						redirect_to(:back)
					end	
				end
			end
	end

	def edit
	end

end