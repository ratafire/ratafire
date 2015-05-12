class FacebookfriendsWorker

	@queue = :facebookfriends_queue

	def self.perform(user_id,facebook_id)
		user = User.find(user_id)
		facebook = Facebook.find(facebook_id)
		Facebook.update_friendship(user,facebook)	
	end

end