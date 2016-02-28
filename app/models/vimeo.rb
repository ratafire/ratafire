class Vimeo < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

    def self.find_for_vimeo_oauth(auth, user_id)
    	where(auth.slice(:uid)).first_or_create do |vimeo|
    		vimeo.uid = auth.uid
    		vimeo.name = auth.info.name
      	    vimeo.nickname = auth.info.nickname
    		vimeo.image = auth.info.pictures.last.link
    		vimeo.description = auth.info.description
    		vimeo.link = auth.info.link
    		vimeo.oauth_token = auth.credentials.token
    		vimeo.oauth_secret = auth.credentials.secret
    		vimeo.user_id = user_id
    		vimeo.save
    	end
    end
end