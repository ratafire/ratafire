class Facebook < ActiveRecord::Base
	# attr_accessible :title, :body
	belongs_to :user
	#has_many :facebookpages, :conditions => {:deleted_at => nil}
	#has_many :facebook_pages, :conditions => {:deleted_at => nil}
	#has_many :facebookupdates, :conditions => { :deleted_at => nil , :valid_update => true }

	def self.find_for_facebook_oauth(auth, user_id)
		facebook_created = false
		if Facebook.find_by_uid(auth.uid) == nil
			facebook.uid = auth.uid
			facebook.name = auth.info.name
			facebook.image = auth.info.image
			facebook.first_name = auth.extra.raw_info.first_name
			facebook.last_name = auth.extra.raw_info.last_name
			facebook.link = auth.extra.raw_info.link
			facebook.username = auth.extra.raw_info.username
			facebook.gender = auth.extra.raw_info.gender
			if auth.extra.raw_info.location != nil then
				facebook.locale = auth.extra.raw_info.location.name
			end
			facebook.user_birthday = auth.extra.raw_info.user_birthday
			facebook.email = auth.info.email
			facebook.bio = auth.extra.raw_info.bio
			if auth.extra.raw_info.education != nil then 
				if auth.extra.raw_info.education.last != nil then
					if auth.extra.raw_info.education.last.concentration != nil then
						facebook.concentration = auth.extra.raw_info.education.last.concentration[0].name
					end
					if auth.extra.raw_info.education.last.school != nil then 
						facebook.school = auth.extra.raw_info.education.last.school.name
					end
				end
			end
			if auth.extra.raw_info.website != nil then
				facebook.website = auth.extra.raw_info.website.split("\n")[0]
			end			
			facebook.oauth_token = auth.credentials.token
			facebook.oauth_expires_at = auth.credentials.expires_at ? auth.credentials.expires_at : nil
			facebook.user_id = user_id
			facebook.save
			facebook_created = true
		end
		#With Facebook
		if facebook_created == false then
			facebook = Facebook.find_by_uid(auth.uid)
			if facebook != nil then
				facebook.uid = auth.uid
				facebook.name = auth.info.name
				facebook.image = auth.info.image
				facebook.first_name = auth.extra.raw_info.first_name
				facebook.last_name = auth.extra.raw_info.last_name
				facebook.link = auth.extra.raw_info.link
				facebook.username = auth.extra.raw_info.username
				facebook.gender = auth.extra.raw_info.gender
				if auth.extra.raw_info.location != nil then
					facebook.locale = auth.extra.raw_info.location.name
				end
				facebook.user_birthday = auth.extra.raw_info.user_birthday
				facebook.email = auth.info.email
				facebook.bio = auth.extra.raw_info.bio
				if auth.extra.raw_info.education != nil then 
					if auth.extra.raw_info.education.last != nil then
						if auth.extra.raw_info.education.last.concentration != nil then
							facebook.concentration = auth.extra.raw_info.education.last.concentration[0].name
						end
						if auth.extra.raw_info.education.last.school != nil then 
							facebook.school = auth.extra.raw_info.education.last.school.name
						end
					end
				end
				if auth.extra.raw_info.website != nil then
					facebook.website = auth.extra.raw_info.website.split("\n")[0]
				end			
				facebook.oauth_token = auth.credentials.token
				facebook.oauth_expires_at = auth.credentials.expires_at ? auth.credentials.expires_at : nil
				facebook.user_id = user_id
				#If the user has facebook page_access_token
				facebook.page_access_token = auth.credentials.token if facebook.page_access_token != nil
				facebook.post_access_token = auth.credentials.token if facebook.post_access_token != nil
				if facebook.facebook_pages.any? then
					facebook.facebook_pages.each do |page|
						page.update_column(:access_token, auth.credentials.token)
					end
				end
				if facebook.facebookpages.any? then
					facebook.facebookpages.each do |page|
						page.update_column(:access_token, auth.credentials.token)
					end
				end
				facebook.save				
			end
		end
	end

	def self.facebook_signup_oauth(auth, user_id) 
		#If this user does not exist
		if user = User.find_by_email(auth.info.email)
			if user.invitation_token
	        	user.update(
					invitation_accepted_at: Time.now,
					invitation_token: nil,
	        	)
	        	#Add score
	        	user.add_score("quest_sm")
			  	if inviter = User.find(user.invited_by_id)
			  		inviter.add_score("quest")
			  	end
		  		#Check achievement
		  		Resque.enqueue(Achievement::RecruitFriend, user.invited_by_id)	
				proceed = true
			end
		else
			proceed = true
		end
		if proceed
			if Facebook.find_by_uid(auth.uid) == nil
				@facebook = Facebook.new
				@facebook.uid = auth.uid
				@facebook.name = auth.info.name
				@facebook.image = auth.info.image
				@facebook.first_name = auth.extra.raw_info.first_name
				@facebook.last_name = auth.extra.raw_info.last_name
				@facebook.link = auth.extra.raw_info.link
				@facebook.username = auth.extra.raw_info.username
				@facebook.gender = auth.extra.raw_info.gender
				if auth.extra.raw_info.location != nil
					@facebook.locale = auth.extra.raw_info.location.name
				end
				@facebook.user_birthday = auth.extra.raw_info.user_birthday
				@facebook.email = auth.info.email
				@facebook.bio = auth.extra.raw_info.bio
				if auth.extra.raw_info.education != nil 
					if auth.extra.raw_info.education.last != nil
						if auth.extra.raw_info.education.last.concentration != nil
							@facebook.concentration = auth.extra.raw_info.education.last.concentration[0].name
						end
						if auth.extra.raw_info.education.last.school != nil
							@facebook.school = auth.extra.raw_info.education.last.school.name
						end
					end
				end
				if auth.extra.raw_info.website != nil
					@facebook.website = auth.extra.raw_info.website.split("\n")[0]
				end
				@facebook.oauth_token = auth.credentials.token
				@facebook.oauth_expires_at = auth.credentials.expires_at ? auth.credentials.expires_at : nil
				@facebook.user_id = user_id
				@facebook.save
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
