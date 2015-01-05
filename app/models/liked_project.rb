class LikedProject < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :project
  belongs_to :liker, class_name: "User"
  #track activities
  include PublicActivity::Model  
  tracked except: [:update, :destroy], owner: ->(controller, model) { controller && controller.current_user }

  #--- Validation --- 
  validates_uniqueness_of :project_id, :scope => :user_id, :message => "You liked this project."
end
