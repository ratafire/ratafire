class Studio::CommunityController < ApplicationController

	#Before filters
	before_filter :load_user

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

protected

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

end