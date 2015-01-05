class RegistrationsController < Devise::RegistrationsController

    layout 'application_clean'
 
   def after_inactive_sign_up_path_for(resource)
    '/discovered'
  end

 def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(params[:user])
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(params[:user])
    end

    if successfully_updated
      flash[:success] = "Settings changed."
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to(@user)
    else
      render "edit"
    end
  end

  def destroy
    resource.soft_delete
    resource.profilephoto.destroy
    Resque.enqueue(DisableWorker,resource.id)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    #When a user is there
    unless user.confirmed_at != nil then
      user.email != params[:user][:email] ||
        params[:user][:password].present?
        
      user.username != params[:user][:username] ||
        params[:user][:password].present?        
    end


  end

    #Set Layouts
  #  def user_layout
  #    case action_name
  #    when "edit", "update"
  #      "settings"
  #    else
  #      "application"
  #    end
  #  end
end