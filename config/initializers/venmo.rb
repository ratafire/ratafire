if Rails.env.production?
	Venmo.configure do |c|
		c.access_token= ENV["VENMO_ACCESS_TOKEN"]
		c.privacy= "friends"
		#private, public, friends are vaild options
		#see Venmo documentation
	end
else
	Venmo.configure do |c|
		c.access_token= ENV["VENMO_ACCESS_TOKEN"]
		c.privacy= "friends"
		#private, public, friends are vaild options
		#see Venmo documentation
	end	
end