class Content::MajorpostsController < ApplicationController

	layout 'profile'

	before_filter :load_majorpost, except: [:create]

	#REST Methods -----------------------------------

	#content_comments POST
	#/content/comments
	def create
		@comment = Comment.new(comment_params)
		if @comment.update(
			user_id: current_user.id
		)
			@majorpost = Majorpost.find(@comment.majorpost_id)
		end
	end

	#content_comment DELETE
	#/content/comments/:id
	def destroy
	end

private

	def load_user
		@user = current_user
	end

	def load_comment
		unless @comment = Comment.find_by_uuid(params[:id])
			unless @comment = Comment.find_by_uuid(params[:comment_id])
			end
		end
	end	

	def comment_params
		params.require(:comment).permit(:user_id,:majorpost_id, :content,:project_id, :reply_id)
	end

end