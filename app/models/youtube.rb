class Youtube < ActiveRecord::Base
    #----------------Relationships----------------
    #Belongs to
    belongs_to :user

    def self.find_for_youtube_oauth(auth, user_id) 
    	where(auth.slice(:uid)).first_or_create do |youtube|
    		youtube.uid = auth.uid
    		youtube.name = auth.info.name
    		youtube.email = auth.info.email
    		youtube.first_name = auth.info.first_name
    		youtube.last_name = auth.info.last_name
    		youtube.image = auth.info.image
    		youtube.token = auth.credentials.token
    		youtube.refresh_token = auth.credentials.refresh_token
    		youtube.expires_at = auth.credentials.expires_at
    		youtube.expires = auth.credentials.expires
    		youtube.sub = auth.extra.raw_info.sub
    		youtube.email_verified = auth.extra.raw_info.email_verified
    		youtube.profile = auth.extra.raw_info.profile
    		youtube.picture = auth.extra.raw_info.picture
    		youtube.gender = auth.extra.raw_info.gender
    		youtube.birthday = auth.extra.raw_info.birthday
    		youtube.locale = auth.extra.raw_info.locale
    		youtube.hd = auth.extra.raw_info.hd
    		youtube.iss = auth.extra.id_info.iss
    		youtube.at_hash = auth.extra.id_info.at_hash
    		youtube.id_info_sub = auth.extra.id_info.sub
    		youtube.azp = auth.extra.id_info.azp
    		youtube.aud = auth.extra.id_info.aud
    		youtube.iat = auth.extra.id_info.iat
    		youtube.exp = auth.extra.id_info.exp
    		youtube.openid_id = auth.extra.id_info.openid_id
    		youtube.save
    	end
    end
end
