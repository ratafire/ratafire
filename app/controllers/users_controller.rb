class UsersController < ApplicationController

  include Devise::Controllers::Helpers

  layout 'application'
  before_filter :signed_in_user,
				only: [:index, :edit, :settings, :goals, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :settings, :goals, :update, :photo]
  before_filter :admin_user,     only: :destroy

  def no_sign_up
	flash[:info] = 'Registrations are not open yet, try sign up for beta instead.'
	redirect_to root_path
  end


  def show
	#Find user by username
	@user = User.find(params[:id])
	active_user
	if @user.website != nil then 
	  unless @user.website[/\Ahttp:\/\//] || @user.website[/\Ahttps:\/\//]
		@user_website = "http://#{@user.website}"
	  else
		@user_website = @user.website
	  end
	end  
	@majorpost = @user.majorposts
	@project = @majorpost.project
	@comments = @user.comments
	@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @user, owner_type: "User").paginate(page: params[:activities], :per_page => 20)
	#Check if the current user is a subscriber
	if user_signed_in? then
		@subscription = Subscription.where(:deleted => false, :activated => true, :subscriber_id => current_user.id, :subscribed_id => @user.id).first
	end
  end

	def new
	unless user_signed_in?
		  @user = User.new
	else
	  redirect_to root_path
	end
	end

  def create
		@user = User.new(params[:user])

		#Save user 
		if @user.save
		  sign_in @user
			flash[:success] = "You have discovered Ratafire!"
			redirect_to @user
		else
			render 'new'
		end

  #end of create	
  end

  def photo
	@user = User.find(params[:id])
  end

  def edit
	@user = User.find(params[:id])
	gon.user_id = @user.id
  end

  #def settings
  #  @user = User.find(params[:id])
  #end

  def update
	respond_to do |format|
	  if @user.update_attributes(params[:user])
		format.json { respond_with_bip(@user) }
		  if params[:user][:profilelarge].blank?
			format.html { redirect_to(:back) }
			flash[:success] = "Ah, new info!"
		  else
			format.html { render :action => "edit" }
		  end
	  else
		format.json { respond_with_bip(@user) }
		format.html { render :action => "edit" }
	  end
	end
  end

  def profile_photo_delete
	@user = User.find(params[:id])
	@user.profilephoto.destroy
	@user.save
	redirect_to(:back)
	flash[:success] = "Photo deleted."
  end

  def projects
	@user = User.find(params[:id])
	@currentprojects = @user.projects.where(:complete => false,:abandoned => false ).paginate(page: params[:current_p], :per_page => 3)
	@completedprojects = @user.projects.where(:complete => true).paginate(page: params[:complete_p], :per_page => 20)
  end

  def projects_past
	@user = User.find(params[:id])
	@abandonedprojects = @user.projects.where(:abandoned => true).paginate(page: params[:page], :per_page => 20)
  end

  def goals
	@user = User.find(params[:id])
	if @user.goals_updated_at != nil then
	  @edit_again = 30-((Time.now - @user.goals_updated_at)/1.day).round
	  if @edit_again < 1 then
		@allow_edit_goals = true
	  else
		@allow_edit_goals = false
	  end 
	end
  end


  def disconnect
	case params[:provider]
	when "facebook"
	  facebook = current_user.facebook
	  facebook.destroy
	  redirect_to(:back)
	  flash[:success] = "Disconnected from Facebook."
	when "twitter"
	  twitter = current_user.twitter
	  twitter.destroy
	  redirect_to(:back)
	  flash[:success] = "Disconnected from Twitter."
	when "github"
	  github = current_user.github
	  github.destroy
	  redirect_to(:back)
	  flash[:success] = "Disconnected from Github."
	when "deviantart"
	  deviantart = current_user.deviantart
	  deviantart.destroy
	  redirect_to(:back)
	  flash[:success] = "Disconnected from Deviantart."
	when "vimeo"
	  vimeo = current_user.vimeo
	  vimeo.destroy
	  redirect_to(:back)
	  flash[:success] = "Disconnected from Vimeo."      
	end
  end
  

  def connect_with_facebook
	@user = User.find(params[:id])
	where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
	  user.facebook_oauth_token = auth.credentials.facebook_oauth_token
	  user.facebook_oauth_expired_at = Time.at(auth.credentials.expires_at)
	  user.facebook = auth.info.uid
	  user.save!
	end
	redirect_to(:back)
  end

  def disable
	@user = User.find(params[:id])
	@user.deactivated_at = Time.now
	@user.disabled = true
	@user.profilephoto.destroy
	@user.save
	Resque.enqueue(DisableWorker,@user.id)
	Devise.sign_out_all_scopes ? sign_out : sign_out(@user)
	flash[:success] = "Farewell "+@user.fullname+"!"
	redirect_to root_path
  end

  private

	def correct_user
	  @user = User.find(params[:id])
	  redirect_to(root_url) unless current_user?(@user)
	end
	
  #Devise 
	def current_user?(user)
	  user == current_user
	end

	def admin_user
	  redirect_to(root_url) unless current_user.admin?
	end

	#Set Layouts
  #  def user_layout
  #    case action_name
  #    when "edit", "goals"
  #      "settings"
  #    else
  #      "application"
  #    end
  #  end

  #See if the user is signed in?
	def signed_in_user
	  unless signed_in?
		redirect_to new_user_session_path, notice:"Please sign in." unless signed_in?
	  end
	end

  #See if the user is active
  def active_user
	if @user.deactivated_at != nil
	  redirect_to(:back)
	end
	rescue ActionController::RedirectBackError
	  redirect_to root_path
  end
end
