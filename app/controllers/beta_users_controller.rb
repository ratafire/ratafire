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

	def status
	end

	def show
		@beta_users = BetaUser.where(:approved => nil, :ignore => nil).paginate(page: params[:page], :per_page => 50)
		
		@beta_users_approved = BetaUser.where(:approved => true).paginate(page: params[:a], :per_page => 50)
		@beta_users_ignored = BetaUser.where(:ignore => true).paginate(page: params[:i], :per_page => 50)
		
		@beta_art = BetaUser.where(:approved => true, :realm => 'art', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_art_a = BetaUser.where(:approved => true, :realm => 'art').paginate(page: params[:page], :per_page => 50)
		
		@beta_music = BetaUser.where(:approved => true, :realm => 'music', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_music_a = BetaUser.where(:approved => true, :realm => 'music').paginate(page: params[:page], :per_page => 50)
		
		@beta_games = BetaUser.where(:approved => true, :realm => 'games', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_games_a = BetaUser.where(:approved => true, :realm => 'games').paginate(page: params[:page], :per_page => 50)
		
		@beta_writing = BetaUser.where(:approved => true,  :realm => 'writing', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_writing_a = BetaUser.where(:approved => true,  :realm => 'writing').paginate(page: params[:page], :per_page => 50)
		
		@beta_videos = BetaUser.where(:approved => true,  :realm => 'videos', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_videos_a = BetaUser.where(:approved => true,  :realm => 'videos').paginate(page: params[:page], :per_page => 50)
		
		@beta_math = BetaUser.where(:approved => true,  :realm => 'math', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_math_a = BetaUser.where(:approved => true,  :realm => 'math').paginate(page: params[:page], :per_page => 50)
		
		@beta_science = BetaUser.where(:approved => true,  :realm => 'science', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_science_a = BetaUser.where(:approved => true,  :realm => 'science').paginate(page: params[:page], :per_page => 50)
		
		@beta_humanity = BetaUser.where(:approved => true,  :realm => 'humanity', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_humanity_a = BetaUser.where(:approved => true,  :realm => 'humanity').paginate(page: params[:page], :per_page => 50)
		
		@beta_engineering = BetaUser.where(:approved => true,  :realm => 'engineering', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_engineering_a = BetaUser.where(:approved => true,  :realm => 'engineering').paginate(page: params[:page], :per_page => 50)
	
	end

	def approve
		@beta_user = BetaUser.find(params[:id])
		User.invite!(:email => @beta_user.email, :username => @beta_user.username, :fullname => @beta_user.fullname, :website => @beta_user.website)
		@beta_user.approved = true
		@beta_user.save
		redirect_to(:back)
		flash[:success] = "You approved "+@beta_user.fullname+" !"
	end

	def ignore
		@beta_user = BetaUser.find(params[:id])
		@beta_user.ignore = true
		@beta_user.save
		redirect_to(:back)
		flash[:success] = "You ignored "+@beta_user.fullname+" !"
	end


private

	def admin_user
      redirect_to(root_url) unless current_user.admin == true
    end

end