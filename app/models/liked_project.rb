class LikedProject < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :project

  #--- Validation --- 
  validates_uniqueness_of :project_id, :scope => :user_id, :message => "You liked this project."
end
