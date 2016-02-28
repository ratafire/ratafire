class Twitter < ActiveRecord::Base
    # attr_accessible :title, :body
    belongs_to :user

    def self.find_for_twitter_oauth(auth, user_id)
    	where(auth.slice(:uid)).first_or_create do |twitter|
    		twitter.uid = auth.uid
    		twitter.name = auth.info.name
            twitter.nickname = auth.info.nickname
    		twitter.image = auth.info.image
    		twitter.location = auth.info.location
    		twitter.description = auth.info.description
    		twitter.link = auth.info.urls.Twitter
    		twitter.oauth_token = auth.credentials.token
    		twitter.oauth_secret = auth.credentials.secret
    		twitter.lang = auth.extra.raw_info.lang
    		twitter.followers_count = auth.extra.raw_info.followers_count
    		twitter.user_id = user_id
    		twitter.save
    	end
    end

end
