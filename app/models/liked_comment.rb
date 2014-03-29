class LikedComment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :comment

  #--- Validation ---
  validates_uniqueness_of :comment_id, :scope => :user_id, :message => "You liked this comment."
end
