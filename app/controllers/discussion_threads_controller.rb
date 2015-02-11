class DiscussionThreadsController < ApplicationController

	def create
		#Prefill
		@discussion_thread = DiscussionThread.new(params[:discussion_thread])
		begin
			@discussion_thread.uuid = SecureRandom.random_number(8388608).to_s
		end while DiscussionThread.find_by_uuid(@discussion_thread.uuid).present?	
		@discussion_thread.perlink = @discussion_thread.uuid.to_s
		@discussion_thread.edit_permission = "free"
		@discussion_thread.commented_at = Time.now
		@discussion_thread.excerpt = Sanitize.clean(@discussion_thread.content)
		@discussion = Discussion.find(params[:discussion_thread][:discussion_id])

		#Change Discussion Commented at time
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@discussion.id,'Discussion')
		if @activity != nil then
			@activity.commented_at = Time.now
			@activity.save
		end

		if @discussion_thread.update_attributes(params[:discussion_thread]) then

			#Set Level Chain
			case @discussion_thread.level
			when 1 then 
			when 2 then 
				@thread_connector = ThreadConnector.new()
				@thread_connector.level_1_id = @discussion_thread.parent_id
				@thread_connector.level_2_id = @discussion_thread.id
				@thread_connector.save
			when 3 then 
				@thread_connector = ThreadConnector.new()
				@thread_connector.level_2_id = @discussion_thread.parent_id
				@thread_connector.level_3_id = @discussion_thread.id
				@thread_connector.save		
			when 4 then 
				@thread_connector = ThreadConnector.new()
				@thread_connector.level_3_id = @discussion_thread.parent_id
				@thread_connector.level_4_id = @discussion_thread.id
				@thread_connector.save
			when 5 then
				@thread_connector = ThreadConnector.new()
				@thread_connector.level_4_id = @discussion_thread.parent_id
				@thread_connector.level_5_id = @discussion_thread.id
				@thread_connector.save								
			end				
			redirect_to(:back)
		else
			redirect_to(:back)
		end

	end

	def show
		@discussion_thread = DiscussionThread.find(params[:id])
		@discussion_thread_new = DiscussionThread.new()
		@discussion = @discussion_thread.discussion
		@next_level = @discussion_thread.level+1
		case @discussion_thread.level 
		when 1 then
			@level_1_threads = @discussion_thread.level_2.paginate(page: params[:page], :per_page => 30)
		end
	end

	def destroy
		@discussion_thread = DiscussionThread.find(params[:id])
		@user = @discussion_thread.creator
		#Set Activities of the Discussion as deleted
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@discussion_thread.id,'DiscussionThread')
		if @activity != nil then
			@activity.deleted = true
			@activity.deleted_at = Time.now
			@activity.save
		end
		#Set Discussion as deleted
		@discussion_thread.deleted = true
		@discussion_thread.deleted_at = Time.now
		@discussion_thread.save
		flash[:success] = "Discussion thread thrown away, and you hit a pine nut."
		redirect_to :back	
	end	

end