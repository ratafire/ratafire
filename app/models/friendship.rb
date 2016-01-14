class Friendship < ActiveRecord::Base
	#attr_accessible :friend_id, :user_id, :user_facebook_uid, :friend_facebook_uid, :friendship_init
	belongs_to :user
	belongs_to :friend, :class_name => "User"	
end
