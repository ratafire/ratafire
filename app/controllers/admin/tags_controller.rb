class Admin::TagsController < ApplicationController

	layout 'profile'

	before_filter :load_user, except:[:index, :edit, :update, :destroy]
	before_filter :load_tag, only:[:edit, :update, :destroy]
	before_filter :is_admin?

	#REST Methods -----------------------------------

	#index_admin_tags GET
	#/admin/tags/index
	def index
		respond_to do |format|
			format.html
			format.json { render json: TagsDatatable.new(view_context) }
		end
	end

	#user_admin_tags POST
	#/users/:user_id/admin/tags
	def create
		#Create tag
		if @tag = Tag.create(tag_params)
			if @tag_image = TagImage.find_by_tag_id(@tag.id)
				@tag_image.update(image: params[:tag][:image])
			end
		end
		redirect_to :back
	end

	#update_admin_tags PATCH
	#/admin/tags/:id
	def update
		if @tag.update(tag_params)
			if @tag_image = TagImage.find_by_tag_id(@tag.id)
				@tag_image.update(image: params[:tag][:image], name: @tag.name, description: @tag.description)
			end
		end
		redirect_to :back
	end	

	#edit_admin_tags GET
	#/admin/tags/:id
	def edit
		@user = current_user
	end

	#user_admin_tags GET
	#/users/:user_id/admin/tags
	def show
		@tag = Tag.new
	end

	#destroy_admin_tags DELETE 
	#/admin/tags/:id
	def destroy
		#Destroy tagging
		if @tag.taggings.count > 0 
			@tag.taggings.each do |tagging|
				tagging.destroy
			end
		end
		#Destroy tag_image
		if @tag_image = TagImage.find_by_tag_id(@tag.id)
			@tag_image.destroy
		end
		@tag.destroy
		redirect_to :back
	end

	#NoREST Methods -----------------------------------

private

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def load_tag
		@tag = Tag.find(params[:id])
	end

	def tag_params
		params.require(:tag).permit(:tag_id, :name, :description, :direct_upload_url)
	end

	def is_admin?
		if current_user.admin != true
			redirect_to root_path
		end
	end	

end