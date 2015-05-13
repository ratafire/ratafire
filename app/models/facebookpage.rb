class Facebookpage < ActiveRecord::Base
	# attr_accessible :title, :body

	belongs_to :user
	belongs_to :facebook
 	before_validation :generate_uuid!, :on => :create
 	has_many :facebookupdates, :conditions => {  :deleted_at => nil ,:valid_update => true }
 	default_scope order: 'facebookpages.created_at DESC'

	def self.create_facebookpage(page_id,user_id)
		where(page_id: page_id).first_or_create do |facebookpage|
			facebook_page = FacebookPage.find_by_page_id(page_id)
			if facebook_page != nil then 
				facebookpage.user_id = user_id
				facebookpage.name = facebook_page.name
				facebookpage.access_token = facebook_page.access_token
				facebookpage.page_id = facebook_page.page_id
				facebookpage.category = facebook_page.category
				facebookpage.mission = facebook_page.mission
				facebookpage.website = facebook_page.website
				facebookpage.link = facebook_page.link
				facebookpage.facebook_id = facebook_page.facebook_id
				facebookpage.city = facebook_page.city
				facebookpage.country = facebook_page.country
				facebookpage.state = facebook_page.state		
				facebookpage.facebookprofile = facebook_page.facebookprofile
				facebookpage.facebookcover = facebook_page.facebookcover
				facebookpage.sync = true
				#About
				user = User.find(user_id)
				facebookpage.about = facebook_page.about
				if facebook_page.about.length < 300 && user != nil then 
					facebookpage.excerpt = "This is "+ user.fullname+" - "+user.tagline+"'s Facebook page: "+facebook_page.name+", in the "+facebook_page.category+" category. "+facebook_page.about+" This page's updates are synced to Ratafire."
				else
					facebookpage.excerpt = facebook_page.about
				end
				facebookpage.save
				facebook_page.update_column(:sync,true)
			end
		end
	end

	def self.update_facebookpage(page_id,user_id)
		facebookpage = Facebookpage.find_by_page_id(page_id)
		if facebookpage != nil then
			facebook_page = FacebookPage.find_by_page_id(page_id)
			if facebook_page != nil then 
				facebookpage.user_id = user_id
				facebookpage.name = facebook_page.name
				facebookpage.access_token = facebook_page.access_token
				facebookpage.page_id = facebook_page.page_id
				facebookpage.category = facebook_page.category
				facebookpage.mission = facebook_page.mission
				facebookpage.website = facebook_page.website
				facebookpage.link = facebook_page.link
				facebookpage.facebook_id = facebook_page.facebook_id
				facebookpage.city = facebook_page.city
				facebookpage.country = facebook_page.country
				facebookpage.state = facebook_page.state		
				facebookpage.facebookprofile = facebook_page.facebookprofile
				facebookpage.facebookcover = facebook_page.facebookcover
				facebookpage.sync = true
				#About
				user = User.find(user_id)
				facebookpage.about = facebook_page.about
				if facebook_page.about.length < 300 && user != nil then 
					facebookpage.excerpt = "This is "+ user.fullname+" - "+user.tagline+"'s Facebook page: "+facebook_page.name+", in the "+facebook_page.category+" category. "+facebook_page.about+" This page's updates are synced to Ratafire."
				else
					facebookpage.excerpt = facebook_page.about
				end
				facebookpage.save
				facebook_page.update_column(:sync,true)				
			end
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
