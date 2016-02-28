class Twitch < ActiveRecord::Base

	belongs_to :user

    def self.find_for_twitch_oauth(auth, user_id)
    	where(auth.slice(:uid)).first_or_create do |twitch|
    		twitch.user_id = user_id
    		twitch.uid = auth.uid
    		twitch.name = auth.info.name
    		twitch.email = auth.info.email
            twitch.nickname = auth.info.nickname
            twitch.description = auth.info.description
    		twitch.image = auth.extra.raw_info.logo
    		twitch.token = auth.credentials.token
    		twitch.expires = auth.credentials.expires
    		twitch.display_name = auth.extra.raw_info.display_name
    		twitch.account_type = auth.extra.raw_info.type
    		twitch.bio = auth.extra.raw_info.bio
    		twitch.link_self = "http://www.twitch.tv/"+auth.info.name
    		twitch.partnered = auth.extra.raw_info.partnered
    		twitch.save
    	end
    end

end
