class StaticPagesController < ApplicationController

  layout :resolve_layout

  before_filter :check_for_mobile


  def home
    @activities = PublicActivity::Activity.order("commented_at desc").where(:featured_home => true).paginate(page: params[:page], :per_page => 20)
  	@user = current_user
    @featured_user = User.find_by_username("colinchromatic")
    @users = User.where(:subscription_status_initial => "Approved",:homepage_fundable => true).order("homepage_fundable_weight desc").paginate(page: params[:fundable], :per_page => 1)[2]
    @users_2 = User.where(:subscription_status_initial => "Approved",:homepage_fundable => true).order("homepage_fundable_weight desc").paginate(page: params[:fundable], :per_page => 2)
  	unless signed_in?
    else
      redirect_to featured_path
    end
  end


  def help
  end

  def about
  end

  def contact
  end

  def terms
  end

  def privacy
  end

  def guidelines
  end

  def faq
  end

  def pricing
  end

  def press
  end

  def mobile_sign_in
    if signed_in?
      redirect_to featured_path
    end
  end

  def mobile_about
  end

private
  
  def resolve_layout
    case action_name
    when "home"
      "plain"
    when "mobile_sign_in"
      "plain"
    else
      "application_clean"
    end
  end

  # def mobile_device?
  #     # Season this regexp to taste. I prefer to treat iPad as non-mobile.
  #     if (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/) then
  #       return true
  #     else
  #       return false
  #     end
  # end

end
