class Facebook < ActiveRecord::Base
	# attr_accessible :title, :body
	belongs_to :user

	def self.find_for_facebook_oauth(auth, user_id)
		where(auth.slice(:uid)).first_or_create do |facebook|
			facebook.uid = auth.uid
			facebook.name = auth.info.name
			facebook.image = auth.info.image
			facebook.first_name = auth.info.first_name
			facebook.last_name = auth.info.last_name
			facebook.link = auth.info.urls.Facebook
			facebook.username = auth.extra.raw_info.username
			facebook.gender = auth.extra.raw_info.gender
			if auth.extra.raw_info.location != nil then
				facebook.locale = auth.extra.raw_info.location.name
			end
			facebook.user_birthday = auth.extra.raw_info.user_birthday
			facebook.email = auth.info.email
			facebook.bio = auth.extra.raw_info.bio
			if auth.extra.raw_info.education != nil then 
				if auth.extra.raw_info.education[0] != nil then
					if auth.extra.raw_info.education[0].concentration != nil then
						facebook.concentration = auth.extra.raw_info.education[0].concentration[0].name
					end
					if auth.extra.raw_info.education[0].school != nil then 
						facebook.school = auth.extra.raw_info.education[0].school.name
					end
				end
			end
			if auth.extra.raw_info.website != nil then
				facebook.website = auth.extra.raw_info.website.split("\n")[0]
			end			
			facebook.oauth_token = auth.credentials.token
			facebook.oauth_expires_at = auth.credentials.expires_at
			facebook.user_id = user_id
			facebook.save
		end
	end

	def self.facebook_signup_oauth(auth, user_id) 
		#If this user does not exist
		if User.find_by_email(auth.info.email) == nil then
			where(auth.slice(:uid)).first_or_create do |facebook|
				facebook.uid = auth.uid
				facebook.name = auth.info.name
				facebook.image = auth.info.image
				facebook.first_name = auth.info.first_name
				facebook.last_name = auth.info.last_name
				facebook.link = auth.info.urls.Facebook
				facebook.username = auth.extra.raw_info.username
				facebook.gender = auth.extra.raw_info.gender
				if auth.extra.raw_info.location != nil then
					facebook.locale = auth.extra.raw_info.location.name
				end
				facebook.user_birthday = auth.extra.raw_info.user_birthday
				facebook.email = auth.info.email
				facebook.bio = auth.extra.raw_info.bio
				if auth.extra.raw_info.education != nil then 
					if auth.extra.raw_info.education[0] != nil then
						if auth.extra.raw_info.education[0].concentration != nil then
							facebook.concentration = auth.extra.raw_info.education[0].concentration[0].name
						end
						if auth.extra.raw_info.education[0].school != nil then 
							facebook.school = auth.extra.raw_info.education[0].school.name
						end
					end
				end
				if auth.extra.raw_info.website != nil then
					facebook.website = auth.extra.raw_info.website.split("\n")[0]
				end
				facebook.oauth_token = auth.credentials.token
				facebook.oauth_expires_at = auth.credentials.expires_at
				facebook.user_id = user_id
				facebook.save
			end
		else
			return false	  
		end	 
	end

	def self.update_friendship(user,facebook)
		#connect to graph api
		begin
			@graph = Koala::Facebook::API.new(facebook.oauth_token)
			if @graph != nil then
				friends = @graph.get_connection("me","friends")
				if friends.any? then
					friends.each do |friend|
						friend_facebook = Facebook.find_by_uid(friend["id"])
						if friend_facebook != nil then 
							friendship = Friendship.where(user_id: user.id, friend_id: friend_facebook.user_id).first_or_create(
								:user_id => user.id,
								:friend_id => friend_facebook.user_id, 
								:user_facebook_uid => friend_facebook.uid,
								:friend_facebook_uid => friend["id"],
								:friendship_init => user.id
							)
							#inverse friendship
							inverse_friendship = Friendship.where(friend_id: user.id, user_id: friend_facebook.user_id).first_or_create(
								:user_id => friend_facebook.user_id, 
								:friend_id => user.id,
								:user_facebook_uid => friend["id"],
								:friend_facebook_uid => friend_facebook.uid
								)					
						end
					end
				end
			end
		rescue Koala::Facebook::APIError => exc	
			logger.error("Can't add facebook friends.")
		end		
	end

end
