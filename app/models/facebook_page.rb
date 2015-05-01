class FacebookPage < ActiveRecord::Base
	# attr_accessible :title, :body
	belongs_to :user

	def self.create_facebook_page(page,user_id,facebook_id)
		where(page_id:page["id"]).first_or_create do |facebookpage|
			facebookpage.user_id = user_id
			facebookpage.facebook_id = facebook_id
			facebookpage.page_id = page["id"]
			facebookpage.name = page["name"]
			facebookpage.access_token = page["access_token"]
			facebookpage.category = page["category"]
			facebookpage.save
		end
	end

end
