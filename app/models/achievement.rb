class Achievement < ActiveRecord::Base

	#----------------Relationships----------------
    belongs_to :user
    has_many :inverse_achievement_relationships,
        :class_name => 'AchievementRelationship'
    has_many :inverse_achievements,
    	:through => :inverse_achievement_relationships

    #----------------Translation----------------

    #translates :name, :description#, :versioning => :paper_trail

end
