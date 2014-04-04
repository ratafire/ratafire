class Deviantart < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

  def self.find_for_deviantart_oauth(auth, user_id)
  	where(auth.slice(:uid)).first_or_create do |deviantart|
  		deviantart.uid = auth.uid
  		deviantart.image = auth.info.image
  		deviantart.nickname = auth.info.nickname
  		deviantart.link = "http://"+auth.info.nickname.to_s+".deviantart.com/"
  		deviantart.oauth_token = auth.credentials.token
  		deviantart.oauth_token_expires_at = auth.credentials.expires_at
  		deviantart.user_id = user_id
  		deviantart.save
  	end
  end  
end
