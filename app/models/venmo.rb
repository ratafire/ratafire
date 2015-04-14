class Venmo < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

  def self.find_for_venmo_oauth(auth, user_id)
  	where(auth.slice(:uid)).first_or_create do |venmo|
  		venmo.uid = auth.uid
  		venmo.username = auth.info.username
      venmo.email = auth.extra.raw_info.email
  		venmo.name = auth.info.name
  		venmo.first_name = auth.info.first_name
  		venmo.last_name = auth.info.last_name
  		venmo.image = auth.extra.raw_info.profile_picture_url
  		venmo.token = auth.credentials.token
  		venmo.expires = auth.credentials.expires
      venmo.balance = auth.extra.raw_info.balance
      venmo.refresh_token = auth.credentials.refresh_token
      venmo.expires_in = auth.credentials.expires_at
      venmo.phone = auth.info.phone
      venmo.profile_url = auth.info.urls.profile
  		venmo.user_id = user_id
  		venmo.save
  	end
  end

end
