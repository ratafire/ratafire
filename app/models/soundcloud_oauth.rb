class SoundcloudOauth < ActiveRecord::Base

	belongs_to :user

    def self.find_for_soundcloud_oauth(auth, user_id)
    	where(auth.slice(:uid)).first_or_create do |soundcloud|
    		soundcloud.user_id = user_id
    		soundcloud.uid = auth.uid
    		soundcloud.name = auth.info.name
    		soundcloud.email = auth.info.email
            soundcloud.nickname = auth.info.nickname
            soundcloud.image = auth.info.image
            soundcloud.location = auth.info.location
    		soundcloud.token = auth.credentials.token
            soundcloud.expires = auth.credentials.expires
            soundcloud.refresh_token = auth.credentials.refresh_token
            soundcloud.kind = auth.extra.raw_info.kind
            soundcloud.permalink = auth.extra.raw_info.permalink
            soundcloud.username = auth.extra.raw_info.username
            soundcloud.full_name = auth.extra.raw_info.full_name
            soundcloud.uri = auth.extra.raw_info.uri
            soundcloud.permalink_url = auth.extra.raw_info.permalink_url
            soundcloud.avatar_url = auth.extra.raw_info.avatar_url
            soundcloud.country = auth.extra.raw_info.country
            soundcloud.city = auth.extra.raw_info.city
            soundcloud.track_count = auth.extra.raw_info.track_count
            soundcloud.playlist_count = auth.extra.raw_info.playlist_count
            soundcloud.public_favorites_count = auth.extra.raw_info.public_favorites_count
            soundcloud.followers_count = auth.extra.raw_info.followers_count
            soundcloud.followings_count = auth.extra.raw_info.followings_count
            soundcloud.plan = auth.extra.raw_info.plan
            soundcloud.private_tracks_count = auth.extra.raw_info.private_tracks_count
            soundcloud.private_playlists_count = auth.extra.raw_info.private_playlists_count
    		soundcloud.save
    	end
    end

end
