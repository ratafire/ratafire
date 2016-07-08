class Studio::NotificationsController < ApplicationController

	#Before filters
	before_filter :load_user

	#REST Methods -----------------------------------

	#NoREST Methods -----------------------------------

	#get_notifications_user_studio_notifications GET
	#/users/:user_id/studio/notifications/get_notifications
	def get_notifications
		if @user.unread_notifications.count > 0
			@notifications = @user.unread_notifications.first(3)
			@notifications.each do |notification|
				notification.update(
					is_read: true
					)
			end
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

end