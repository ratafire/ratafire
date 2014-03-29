class TagRelationshipsController < ApplicationController

	def follow
		@user = User.find(params[:user_id])
		@tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
		@user.tag_list.add(@tag.name)
		@user.save
		render :nothing => true
	end

	def destroy
		@user = User.find(params[:user_id])
		@tag = ActsAsTaggableOn::Tag.find(params[:tag_id])		
		@user.tag_list.remove(@tag.name)
		@user.save
		render :nothing => true
	end
end	