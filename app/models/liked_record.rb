class LikedRecord < ActiveRecord::Base

	belongs_to :past_liker, class_name: "User"
	belongs_to :past_liked, class_name: "User"

	belongs_to :liker, class_name: "User"
	belongs_to :liked, class_name: "User"

end
