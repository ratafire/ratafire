class Admin::DashboardsController < ApplicationController

	layout 'profile'

	protect_from_forgery :except => [:create]

	#Before filters
	before_filter :authenticate_user!
	before_filter :load_user
	before_filter :is_admin?

	#NoREST Methods -----------------------------------
	#dashboard_user_admin_dashboard GET
	#/users/:user_id/admin/dashboard/dashboard
	def dashboard
		@popoverclass = SecureRandom.hex(16)
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_type: "User", :published => true,trackable_type: ["Majorpost"], :sub_category => nil).page(params[:page]).per_page(1)
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

	def is_admin?
		if current_user.admin != true
			redirect_to root_path
		end
	end

end