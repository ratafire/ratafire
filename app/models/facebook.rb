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
  		facebook.username = auth.info.id
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
end
