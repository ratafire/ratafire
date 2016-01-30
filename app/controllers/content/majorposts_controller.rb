class Content::MajorpostsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_majorpost, except: [:create]

	#After filters
	after_filter :prepare_unobtrusive_flash

	def new
	end
	
	def create
		@majorpost = Majorpost.new(majorpost_params)
		if @majorpost.update(
			user_id: current_user.id,
			published: Time.now
			)
			#Update Activity
			update_majorpost_activity
		else
			flash[:error] = @majorpost.errors.full_messages.to_sentence
		end
	end

	def update
	end

	def destroy
		#Set Majorpost as deleted
		@majorpost.update(
			deleted: true,
			deleted_at: Time.now
			)
		#Delete majorpost activity
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
		@activity.update(
			deleted: true,
			deleted_at: @majorpost.deleted_at
			) unless @activity.nil?
	end	

private

	def load_majorpost
		@majorpost = Majorpost.find_by_uuid(params[:id])
	end

	def update_majorpost_activity
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@activity.update(
				published: @majorpost.published,
				tag_list: @majorpost.tag_list
			)
		end
	end

	def majorpost_params
		params.require(:majorpost).permit(:user_id,:title, :content, :tag_list, :uuid, :published, :published_at)
	end

end