class StaticPagesController < ApplicationController

  layout :resolve_layout

  before_filter :check_for_mobile, :only => :home


  def home
    @activities = PublicActivity::Activity.order("commented_at desc").where(:featured_home => true).paginate(page: params[:page], :per_page => 3)
  	@user = current_user
    @featured_user = User.find_by_username("colinchromatic")
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

private
  
  def resolve_layout
    case action_name
    when "home"
      "plain"
    else
      "application_clean"
    end
  end

end
