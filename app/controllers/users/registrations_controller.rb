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
	      #if is_flashing_format?
	      #  flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
	      #    :update_needs_confirmation : :updated
	      #  set_flash_message :notice, flash_key
	      #  redirect_to(:back)
	      #end
	      sign_in resource_name, resource, bypass: true
	    else
	      clean_up_passwords resource
	      redirect_to(:back)
	    end
	end

	# POST /resource
	def create
		build_resource(sign_up_params)
		if I18n.locale == :zh
			resource.fullname = params[:user][:lastname] + params[:user][:firstname]
			resource.preferred_name = params[:user][:lastname] + params[:user][:firstname]
		else
			resource.fullname = params[:user][:firstname] + ' ' + params[:user][:lastname]
			resource.preferred_name = params[:user][:firstname] + ' ' + params[:user][:lastname]
		end
		resource.save
		yield resource if block_given?
		if resource.persisted?
		  	Profilephoto.create(
		  		user_id: resource.id,
		  		user_uid: resource.uid,
		  		skip_everafter: true
		  	)
		  	Profilecover.create(
		  		user_id: resource.id,
		  		user_uid: resource.uid,
		  		skip_everafter: true
		  	)			
		  if resource.active_for_authentication?
		    set_flash_message! :notice, :signed_up
		    sign_up(resource_name, resource)
		    respond_with resource, location: after_sign_up_path_for(resource)
		  else
		    set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
		    expire_data_after_sign_in!
		    respond_with resource, location: after_inactive_sign_up_path_for(resource)
		  end
		else
			clean_up_passwords resource
			set_minimum_password_length
			respond_with resource
		end
	end	

	#NoREST Methods -----------------------------------


protected

    def after_sign_up_path_for(resource)
       if request.referrer == 'users/sign_up'
       		profile_url_path(resource.username)
       else
       		request.referrer
       end
    end    

	def after_update_path_for(resource)
	    render :nothing => true
	end

	def sign_up_params
		params.require(:user).permit(:email, :password, :firstname, :lastname)
	end	

	def load_user
		@user = User.find_by_username(params[:id])
	end

end