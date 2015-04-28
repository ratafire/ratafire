class UserVenmo < ActiveRecord::Base
	# attr_accessible :title, :body
	belongs_to :user
	require 'rest-client'

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

  	def refresh_token_if_expired
  		if token_expired?
  			if Rails.env.production?
  				response    = RestClient.post "http://localhost:3000/oauth/token", :grant_type => 'refresh_token', :refresh_token => self.refresh_token, :client_id => ENV['VENMO_CLIENT_ID'], :client_secret => ENV['VENMO_CLIENT_SECRET'] 
  			else
  				response    = RestClient.post "https://www.ratafire.com/oauth/token", :grant_type => 'refresh_token', :refresh_token => self.refresh_token, :client_id => ENV['VENMO_SANDBOX_CLIENT_ID'], :client_secret => ENV['VENMO_SANDBOX_CLIENT_SECRET'] 
  			end
  			refreshhash = JSON.parse(response.body)

  			token_will_change!
  			expiresat_will_change!

  			self.token     = refreshhash['access_token']
  			self.expires_in = refreshhash["expires_in"]

  			self.save
  			puts 'Saved'
  		end
  	end

  	def token_expired?
  		expiry = Time.at(self.expires_in.to_i) 
  		return true if expiry < Time.now # expired token, so we should quickly return
  		token_expires_at = expiry
  		save if changed?
  		false # token not expired. :D
	end  

end
