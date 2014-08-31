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
			facebook.locale = auth.extra.raw_info.location
			facebook.user_birthday = auth.extra.raw_info.user_birthday
			facebook.email = auth.info.email
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
				facebook.locale = auth.extra.raw_info.location
				facebook.user_birthday = auth.extra.raw_info.user_birthday
				facebook.email = auth.info.email
				facebook.oauth_token = auth.credentials.token
				facebook.oauth_expires_at = auth.credentials.expires_at
				facebook.user_id = user_id
				facebook.save
				if User.find_by_username(auth.extra.raw_info.username) == nil then
					user = User.find(user_id)
					user.fullname = auth.info.name
					user.email = auth.info.email
					user.username = auth.extra.raw_info.username	
					user.save(:validate => false)		
				else
					user = User.find(user_id)
					user.fullname = auth.info.name
					user.email = auth.info.email	
					user.save(:validate => false)						
				end
			end
		else
			return false	  
		end	 
	end

end
