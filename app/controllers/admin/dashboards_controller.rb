class Admin::DashboardsController < ApplicationController

	layout 'profile'

	protect_from_forgery :except => [:create]

	#Before filters
	before_filter :load_user

	#NoREST Methods -----------------------------------
	#dashboard_user_admin_dashboard GET
	#/users/:user_id/admin/dashboard/dashboard
	def dashboard
	end


private

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

end