class Studio::AchievementsController < ApplicationController

	layout 'studio'

	#Before filters
	before_filter :authenticate_user!
	before_filter :load_user
	before_filter :correct_user

	#REST Methods -----------------------------------

	# user_studio_achievements GET
	# /users/:user_id/studio/achievements
	def show
		@achievements = (@user.achievements.where(level: 1) + Achievement.where(level: 1, hidden: false).order("created_at desc")).uniq.paginate(page: params[:page], per_page: 20)
	end

	#noREST Methods -----------------------------------

	# general_user_studio_achievements GET
	# /users/:user_id/studio/achievements/general
	def general
		@achievements = (@user.achievements.where(level: 1, category: 'general') + Achievement.where(level: 1, hidden: false, category: 'general').order("created_at desc")).uniq.paginate(page: params[:page], per_page: 20)
	end

	# exploration_user_studio_achievements GET
	# /users/:user_id/studio/achievements/exploration
	def exploration
		@achievements = (@user.achievements.where(level: 1, category: 'exploration') + Achievement.where(level: 1, hidden: false, category: 'exploration').order("created_at desc")).uniq.paginate(page: params[:page], per_page: 20)
	end

	# social_user_studio_achievements GET
	# /users/:user_id/studio/achievements/social
	def social
		@achievements = (@user.achievements.where(level: 1, category: 'social') + Achievement.where(level: 1, hidden: false, category: 'social').order("created_at desc")).uniq.paginate(page: params[:page], per_page: 20)
	end

protected

	def load_user
		#Load user by username due to FriendlyID
		unless @user = User.find_by_uid(params[:user_id])
			unless @user = User.find_by_username(params[:user_id])
				@user = User.find(params[:user_id])
			end
		end
	end	

	def correct_user
		if current_user != @user 
			if @user.admin
			else
				redirect_to root_path
			end
		else
			
		end
	end	

end