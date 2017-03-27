class AchievementCounter < ActiveRecord::Base
	belongs_to :user
	belongs_to :achievement
	belongs_to :achievement_relationship
end
