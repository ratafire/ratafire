class Achievement < ActiveRecord::Base
	
    #----------------Utilities----------------

    #Default scope
    default_scope  { order(:created_at => :desc) }

	#----------------Relationships----------------
    belongs_to :user
    has_many :inverse_achievement_relationships,
        :class_name => 'AchievementRelationship'
    has_many :inverse_achievements,
    	:through => :inverse_achievement_relationships
    has_one :achievement_counter

    #----------------Translation----------------

    #translates :name, :description#, :versioning => :paper_trail

end
