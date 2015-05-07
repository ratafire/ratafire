class FacebookPage < ActiveRecord::Base
	# attr_accessible :title, :body
	belongs_to :user
 	before_validation :generate_uuid!, :on => :create	

	def self.create_facebook_page(page,user_id,facebook_id)
		where(page_id:page["id"]).first_or_create do |facebookpage|
			page_graph = Koala::Facebook::API.new(page["access_token"])
			if page_graph != nil then
				response = page_graph.get_object('me')
				facebookpage.about = response["about"]
				facebookpage.link = response["link"]
				if response["location"] != nil then 
					facebookpage.city = response["location"]["city"]
					facebookpage.country = response["location"]["country"]
					facebookpage.state = response["location"]["state"]
				end
				facebookpage.mission = response["mission"]
				facebookpage.website = response["website"]
				#Profile photo
				photo = page_graph.get_picture(page["id"], type: :large)
				if photo != nil then
					facebookpage.facebookprofile = URI.parse(photo)
				end
				#Cover photo
				if response["cover"]["source"] != nil then
					facebookpage.facebookcover = response["cover"]["source"]
				end
			end
			facebookpage.user_id = user_id
			facebookpage.facebook_id = facebook_id
			facebookpage.page_id = page["id"]
			facebookpage.name = page["name"]
			facebookpage.access_token = page["access_token"]
			facebookpage.category = page["category"]
			facebookpage.save
		end
	end

	def self.update_facebook_page(page,user_id,facebook_id)
		facebookpage = FacebookPage.find_by_page_id(page["id"])
		if facebookpage != nil then	
			page_graph = Koala::Facebook::API.new(page["access_token"])
			if page_graph != nil then
				response = page_graph.get_object('me')
				facebookpage.about = response["about"]
				facebookpage.link = response["link"]
				if response["location"] != nil then 
					facebookpage.city = response["location"]["city"]
					facebookpage.country = response["location"]["country"]
					facebookpage.state = response["location"]["state"]
				end
				facebookpage.mission = response["mission"]
				facebookpage.website = response["website"]
				#Profile photo
				photo = page_graph.get_picture(page["id"], type: :large)
				if photo != nil then
					facebookpage.facebookprofile = URI.parse(photo)
				end
				#Cover photo
				if response["cover"]["source"] != nil then
					facebookpage.facebookcover = response["cover"]["source"]
				end				
			end
			facebookpage.user_id = user_id
			facebookpage.facebook_id = facebook_id
			facebookpage.page_id = page["id"]
			facebookpage.name = page["name"]
			facebookpage.access_token = page["access_token"]
			facebookpage.category = page["category"]
			facebookpage.save	
		end	
	end

	has_attached_file :facebookprofile, :styles => {:medium => "128x171#", :small => "128x128#", :small64 => "64x64#", :tiny => "40x40#"},
	:default_url => "/assets/projecticon_:style.jpg",
	      :url =>  "/:class/uploads/:id/:style/:escaped_filename2",
      #If s3
      :path => "/:class/uploads/:id/:style/:escaped_filename2",
      :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/s3_profile.yml"

	has_attached_file :facebookcover, :styles => {:preview => ["790", :jpg], :thumbnail => ["171x96#",:jpg]}, :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
	:default_url => "/assets/projecticon_:style.jpg",
	      :url =>  "/:class/uploads/:id/:style/:escaped_filename3",
      #If s3
      :path => "/:class/uploads/:id/:style/:escaped_filename3",
      :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/s3_profile.yml"
	
	Paperclip.interpolates :escaped_filename2 do |attachment, style|
		attachment.instance.normalized_profile_file_name
	end    

	def normalized_profile_file_name
		"#{self.id}-#{self.facebookprofile_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
	end	

	Paperclip.interpolates :escaped_filename3 do |attachment, style|
		attachment.instance.normalized_profile_file_name3
	end    

	def normalized_profile_file_name3
		"#{self.id}-#{self.facebookcover_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
	end	

	def generate_uuid!
		begin
			self.uuid = SecureRandom.hex(16)
		end while AmazonRecipient.find_by_uuid(self.uuid).present?
	end

end
