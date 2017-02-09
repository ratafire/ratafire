class Admin::UsersController < ApplicationController

	layout 'profile'

	protect_from_forgery :except => [:create]

	#Before filters
	before_filter :authenticate_user!
	before_filter :is_admin?

	#REST Methods -----------------------------------

	#index_admin_users GET
	#/admin/users/index	
	def index
		respond_to do |format|
			format.html
			format.json { render json: UsersDatatable.new(view_context) }
		end		
	end

	#admin_users GET
	#/users/:user_id/admin/users
	def show
	end


private

	def is_admin?
		if current_user.admin != true
			redirect_to root_path
		end
	end

end