class ApplicationController < ActionController::Base

	layout :layout_by_resource

	include PublicActivity::StoreController

	protect_from_forgery

	include SessionsHelper

	# Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  #Mobile Pages
  def check_for_mobile
    prepare_for_mobile #if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
    # prepend_view_path "app/views/mobile" if mobile_device?
  end

  def mobile_device?
      # Season this regexp to taste. I prefer to treat iPad as non-mobile.
      if (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/) then
        return true
      else
        return false
      end
  end
  helper_method :mobile_device?  

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  helper_method :resource, :resource_name, :devise_mapping

protected

def layout_by_resource
  if devise_controller? 
    "application_clean"
  else
    "application"
  end
end 

end





