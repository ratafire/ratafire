class Admin::EmailsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user, except: [:index]
	before_filter :is_admin?

	#REST Methods -----------------------------------

	#index_admin_emails GET
	#/admin/emails/index
	def index
		
	end	

	#admin_emails GET
	#/admin/emails
	def show
		@email = Email.new
	end

	#admin_emails POST
	#/admin/emails
	def create
		@email = Email.new(email_params)
		if @email.update(status: "submitted")
			Resque.enqueue(Email::Newsletter, @email.id)
		end
		redirect_to(:back)
	end

private

	def load_user
		#Load user by username due to FriendlyID
		@user = current_user
	end

	def email_params
		params.require(:email).permit(:user_id,:title, :content)
	end

	def is_admin?
		if current_user.admin != true
			redirect_to root_path
		end
	end

end