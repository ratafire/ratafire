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

protected

def layout_by_resource
  if devise_controller? 
    "application_clean"
  else
    "application"
  end
end 

end





