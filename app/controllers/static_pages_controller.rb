class StaticPagesController < ApplicationController

  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update, :photo]
  before_filter :admin_user,     only: :destroy

  layout :resolve_layout

  def home
    @activities = PublicActivity::Activity.order("commented_at desc").where(:featured_home => true).paginate(page: params[:page], :per_page => 3)
  	@user = current_user
  	unless signed_in?
    else
      redirect_to @user
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
