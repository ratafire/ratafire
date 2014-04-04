class BetaUsersController < ApplicationController
	
	layout 'application'
	before_filter :admin_user, only: [:show]

	def new
		@user = BetaUser.new
	end

	def create
		@beta_user = BetaUser.new(params[:beta_user])
		if @beta_user.save
			flash[:success] = "You have submitted your beta application! We will inform you if you are selected as a beta user."
			redirect_to '/discovered'
		else
			redirect_to :back
		end
	end

	def show
		@beta_users = BetaUser.where(:approved => nil, :ignore => nil).paginate(page: params[:page], :per_page => 50)
		@beta_art = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'art', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_music = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'music', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_games = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'games', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_writing = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'writing', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_videos = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'videos', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_math = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'math', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_science = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'science', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_humanity = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'humanity', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_engineering = BetaUser.where(:approved => nil, :ignore => nil, :realm => 'engineering', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_non = BetaUser.where(:approved => nil, :ignore => nil, :creator => nil).paginate(page: params[:page], :per_page => 50)
	end

	def approve
	end

	def ignore
	end

private

	def admin_user
      redirect_to(root_url) unless current_user.admin == true
    end

end