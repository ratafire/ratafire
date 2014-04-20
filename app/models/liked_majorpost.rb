class LikedMajorpost < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :majorpost

  #--- Validation ---
  validates_uniqueness_of :majorpost_id, :scope => :user_id, :message => "You liked this major post."
end
