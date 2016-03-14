class Users::RegistrationsController < Devise::RegistrationsController

	layout 'profile'

	protect_from_forgery :except => [:update]

	#Before filters
	before_filter :load_user, only:[:update]

	#REST Methods -----------------------------------

	#content_user PATCH
	def update
	    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
	    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

	    resource_updated = update_resource(resource, account_update_params)
	    yield resource if block_given?
	    if resource_updated
	      if is_flashing_format?
	        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
	          :update_needs_confirmation : :updated
	        set_flash_message :notice, flash_key
	        redirect_to(:back)
	      end
	      sign_in resource_name, resource, bypass: true
	    else
	      clean_up_passwords resource
	      redirect_to(:back)
	    end
	end

	#NoREST Methods -----------------------------------
	def after_update_path_for(resource)
	    render :nothing => true
	end

protected

	def user_params
		params.require(:user).permit(:email, :current_password)
	end	

	def load_user
		@user = User.find_by_username(params[:id])
	end

end