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
		@beta_art = BetaUser.where(:approved => true, :realm => 'art', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_art_a = BetaUser.where(:approved => true, :realm => 'art')
		@beta_art_cp = BetaUser.where(:approved => nil, :realm => 'art', :creator => true)
		@beta_art_p = BetaUser.where(:approved => nil, :realm => 'art')
		
		@beta_music = BetaUser.where(:approved => true, :realm => 'music', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_music_a = BetaUser.where(:approved => true, :realm => 'music')
		@beta_music_cp = BetaUser.where(:approved => nil, :realm => 'music', :creator => true)
		@beta_music_p = BetaUser.where(:approved => nil, :realm => 'music')
		
		@beta_games = BetaUser.where(:approved => true, :realm => 'games', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_games_a = BetaUser.where(:approved => true, :realm => 'games')
		@beta_games_cp = BetaUser.where(:approved => nil, :realm => 'games', :creator => true)
		@beta_games_p = BetaUser.where(:approved => nil, :realm => 'games')
		
		@beta_writing = BetaUser.where(:approved => true,  :realm => 'writing', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_writing_a = BetaUser.where(:approved => true,  :realm => 'writing')
		@beta_writing_cp = BetaUser.where(:approved => nil, :realm => 'writing', :creator => true)
		@beta_writing_p = BetaUser.where(:approved => nil, :realm => 'writing')
		
		@beta_videos = BetaUser.where(:approved => true,  :realm => 'videos', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_videos_a = BetaUser.where(:approved => true,  :realm => 'videos')
		@beta_videos_cp = BetaUser.where(:approved => nil, :realm => 'videos', :creator => true)
		@beta_videos_p = BetaUser.where(:approved => nil, :realm => 'videos')
		
		@beta_math = BetaUser.where(:approved => true,  :realm => 'math', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_math_a = BetaUser.where(:approved => true,  :realm => 'math')
		@beta_math_cp = BetaUser.where(:approved => nil, :realm => 'math', :creator => true)
		@beta_math_p = BetaUser.where(:approved => nil, :realm => 'math')
		
		@beta_science = BetaUser.where(:approved => true,  :realm => 'science', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_science_a = BetaUser.where(:approved => true,  :realm => 'science')
		@beta_science_cp = BetaUser.where(:approved => nil, :realm => 'science', :creator => true)
		@beta_science_p = BetaUser.where(:approved => nil, :realm => 'science')
		
		@beta_humanity = BetaUser.where(:approved => true,  :realm => 'humanity', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_humanity_a = BetaUser.where(:approved => true,  :realm => 'humanity')
		@beta_humanity_cp = BetaUser.where(:approved => nil, :realm => 'humanity', :creator => true)
		@beta_humanity_p = BetaUser.where(:approved => nil, :realm => 'humanity')
		
		@beta_engineering = BetaUser.where(:approved => true,  :realm => 'engineering', :creator => true).paginate(page: params[:page], :per_page => 50)
		@beta_engineering_a = BetaUser.where(:approved => true,  :realm => 'engineering')
		@beta_engineering_cp = BetaUser.where(:approved => nil, :realm => 'engineering', :creator => true)
		@beta_engineering_p = BetaUser.where(:approved => nil, :realm => 'engineering')
	
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

	def applied_users
		respond_to do |format|
    		format.html
    		format.json { render json: AppliedUsersDatatable.new(view_context) }
  		end				
	end

	def approved_users
		respond_to do |format|
    		format.html
    		format.json { render json: ApprovedUsersDatatable.new(view_context) }
  		end				
	end

	def ignored_users
		respond_to do |format|
    		format.html
    		format.json { render json: IgnoredUsersDatatable.new(view_context) }
  		end				
	end

private

	def admin_user
      redirect_to(root_url) unless current_user.admin == true
    end

end