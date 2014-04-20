class LikedComment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :comment
  belongs_to :project_comment

  #--- Validation ---
  validates_uniqueness_of :comment_id, :scope => :user_id, :message => "You liked this comment."
  validates_uniqueness_of :project_comment_id, :scope => :user_id, :message => "You liked this comment."
end
