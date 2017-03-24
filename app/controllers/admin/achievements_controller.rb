class Admin::AchievementsController < ApplicationController

	layout 'profile'

	before_filter :load_user, except:[:index, :edit, :update, :destroy]
	before_filter :load_achievement, only:[:edit, :update, :destroy]
	before_filter :is_admin?

	#REST Methods -----------------------------------

	# index_admin_achievements GET
	# /admin/achievements/index
	def index
		respond_to do |format|
			format.html
			format.json { render json: AchievementsDatatable.new(view_context) }
		end
	end

	# admin_achievements POST
	# /admin/achievements
	def create
		unless I18n.locale == :zh
			if @achievement = Achievement.create(achievement_params)
				#Create Merit Badge
				# unless Merit::Badge.by_name(params[:achievement][:name]).count > 0
				# 	@badge = Merit::Badge.create!(
				# 		id: @achievement.id,
				# 		name: @achievement.name, 
				# 		description: @achievement.description,
				# 		level: @achievement.level,
				# 		custom_fields: {
				# 			image: @achievement.image,
				# 			category: @achievement.category,
				# 			sub_category: @achievement.sub_category,
				# 			achievement_points: @achievement.achievement_points,
				# 			achievement_id: @achievement.achievement_id,
				# 			hidden: @achievement.hidden
				# 		}
				# 	)
				# end
			end
		end
		redirect_to :back
	end

	# update_admin_achievements PATCH
	# /admin/achievements/:id
	def update
		if @achievement.update(achievement_params)
			# if @badge = Merit::Badge.find(@achievement.id)
			# 	@badge.update(
			# 		name: @achievement.name, 
			# 		description: @achievement.description,
			# 		level: @achievement.level,
			# 		custom_fields: {
			# 			image: @achievement.image,
			# 			category: @achievement.category,
			# 			sub_category: @achievement.sub_category,
			# 			achievement_points: @achievement.achievement_points,
			# 			achievement_id: @achievement.achievement_id,
			# 			description_zh: @achievement.description_zh,
			# 			name_zh: @achievement.name_zh,
			# 			hidden: @achievement.hidden
			# 		}
			# 	)
			# end
		end
		redirect_to :back
	end

	# edit_admin_achievements GET
	# /admin/achievements/:id
	def edit
	end

	# admin_achievements GET
	# /admin/achievements
	def show
		@achievement = Achievement.new
	end

	# destroy_admin_achievements DELETE
	# /admin/achievements/:id
	def destroy
	end

	#NoREST Methods -----------------------------------


private

	def load_user
		#Load user by username due to FriendlyID
		@user = current_user
	end

	def load_achievement
		@achievement = Achievement.find(params[:id])
	end

	def achievement_params
		params.require(:achievement).permit(:achievement_id, :name, :name_zh, :description, :description_zh, :image, :category, :sub_category, :level, :achievement_points, :hidden)
	end

	def is_admin?
		if current_user.admin != true
			redirect_to root_path
		end
	end	

end