class Pinterest < ActiveRecord::Base

  belongs_to :user

    def self.find_for_pinterest_oauth(auth, user_id)
    	where(auth.slice(:uid)).first_or_create do |pinterest|
    		pinterest.uid = auth.uid
    		pinterest.fist_name = auth.info.first_name
      	    pinterest.last_name = auth.info.last_name
    		pinterest.url = auth.info.url
    		pinterest.save
    	end
    end

end
