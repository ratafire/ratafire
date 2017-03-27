class AchievementRelationship < ActiveRecord::Base
	belongs_to :user
	belongs_to :achievement
	has_one :achievement_counter
end
