class LikedActivity < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :liker, class_name: "User"
  belongs_to :liked_activities, class_name: "PublicActivity::Activity"
end
