class Watched < ActiveRecord::Base
  attr_accessible :user_id, :project_id
  belongs_to :user
  belongs_to :project
  belongs_to :watcher, class_name: "User"

  #track activities
  include PublicActivity::Model  
  tracked except: [:update, :destroy], owner: ->(controller, model) { controller && controller.current_user }

  #--- Validation --- 
  validates_uniqueness_of :project_id, :scope => :user_id, :message => "You are already watching this project."

end
