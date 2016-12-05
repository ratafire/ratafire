class Studio::CommunityController < ApplicationController

	layout 'studio'

	#Before filters
	before_filter :authenticate_user!
	before_filter :load_user
	before_filter :correct_user

	#REST Methods -----------------------------------

	#NoREST Methods -----------------------------------

	#backed_user_studio_community GET
	#/users/:user_id/studio/community/backed
	def backed
	end

	#backers_user_studio_community GET
	#/users/:user_id/studio/community/backers
	def backers
	end

	#followed_user_studio_community GET
	#/users/:user_id/studio/community/followed
	def followed
	end

	#followers_user_studio_community GET
	#/users/:user_id/studio/community/followers
	def followers
	end

	#backed_datatable_user_studio_community GET
	#/users/:user_id/studio/community/backed_datatable
	def backed_datatable
		respond_to do |format|
			format.html
			format.json { render json: BackedDatatable.new(view_context) }
		end
	end

	#backers_datatable_user_studio_community GET
	#/users/:user_id/studio/community/backers_datatable
	def backers_datatable
		respond_to do |format|
			format.html
			format.json { render json: BackersDatatable.new(view_context) }
		end
	end

	#followed_datatable_user_studio_community GET
	#/users/:user_id/studio/community/followed_datatable
	def followed_datatable
		respond_to do |format|
			format.html
			format.json { render json: FollowedDatatable.new(view_context) }
		end
	end

	#followers_datatable_user_studio_community GET
	#/users/:user_id/studio/community/followers_datatable
	def followers_datatable
		respond_to do |format|
			format.html
			format.json { render json: FollowersDatatable.new(view_context) }
		end
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def correct_user
		if current_user != @user 
			if @user.admin
			else
				redirect_to root_path
			end
		else
			
		end
	end	

end