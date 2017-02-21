class Ibifrost < ActiveRecord::Base
	#----------------Utilities----------------

	#--------Encryption--------
	 attr_encrypted :bifrost, key: ENV['KEYSTONE']

end