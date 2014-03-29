class TagRelationship < ActiveRecord::Base
  attr_accessible :user_id, :tag_id

  belongs_to :tag_follower, class_name: "User"
  belongs_to :tag_followed, class_name: "ActsAsTaggableOn::Tag"

  #--- Validation ---
  validates_uniqueness_of :tag_id, :scope => :user_id, :message => "You are following this tag."

end
