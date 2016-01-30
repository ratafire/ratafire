class Friendship::FriendshipController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user, except: [:destroy]

	#Display user friends
	def friends
		@friends = @user.friends.page(params[:page]).per_page(5)
	end

	def destroy
		@friendship = Friendship.find_by_uuid(params[:id])
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

protected

	def load_user
		#Load user by username due to FriendlyID
		@user = User.find_by_username(params[:username])
	end	

end