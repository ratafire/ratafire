class Facebookupdate < ActiveRecord::Base

	belongs_to :user
	belongs_to :facebookpage
	require 'date'

  	include PublicActivity::Model

  	# attr_accessible :title, :body
	def self.create_facebookupdate(response, user_id, facebookpage_id, facebook_id,page_id)
		where(uid: response["id"]).first_or_create do |update|
			#comment info
			update.uid = response["id"]
			update.user_id = user_id
			update.facebook_id = facebook_id
			update.facebookpage_id = facebookpage_id
			update.page_id = page_id
			if response["from"] != nil then 
				update.from_name = response["from"]["name"]
				update.from_category = response["from"]["category"]
				update.from_id = response["from"]["id"]
			end
			update.message = response["message"]
			update.story = response["story"]
			update.link = response["link"]
			if response["actions"] != nil then
				update.facebook_link = response["actions"][0]["link"]
			end
			if response["picture"] != nil then
				update.facebookimage = URI.parse(response["picture"])
			end
			update.status_type = response["status_type"]
			update.post_type = response["type"]
			update.description = response["description"]
			update.source = response["source"]
			update.name = response["name"]
			update.caption = response["caption"]
			update.object_id = response["object_id"]
			#If the post is a video post
			if response["type"] == "video" then
				#If the post has youtube video
				if response["caption"] == "youtube.com" then
					video_regexp = [ /^(?:https?:\/\/)?(?:www\.)?youtube\.com(?:\/v\/|\/watch\?v=)([A-Za-z0-9_-]{11})/, 
                   /^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([A-Za-z0-9_-]{11})/,
                   /^(?:https?:\/\/)?(?:www\.)?youtube\.com\/user\/[^\/]+\/?#(?:[^\/]+\/){1,4}([A-Za-z0-9_-]{11})/
                   ]
                   video_regexp.each do |v|
                   		match = v.match(response["source"])
                   		if match != nil then
                   			update.youtube_video = match[1]
                   		end
                   end
				else
					#If the post has vimeo video
					if response["caption"] == "vimeo.com" then
						if response["source"] =~ /^(http|https):\/\/(?:.*?)\.?vimeo\.com\/(watch\?[^#]*v=(\w+)|(\d+))/ then
							update.vimeo_video = response["source"][/^(http|https):\/\/(?:.*?)\.?vimeo\.com\/(watch\?[^#]*v=(\w+)|(\d+))/, 2]
						else
							if response["source"].split("/")[4].split("?")[0] != nil then 
								update.vimeo_video = response["source"].split("/")[4].split("?")[0]
							else
								update.vimeo_video = response["source"].split("/")[4]
							end
						end
					end
				end
			end
			update.save
			#Change created_at
			date = DateTime.parse(response["created_time"])
			if date != nil then 
				update.update_column(:created_at,date)
			end
			#Make Activity
			updateactivity = update.create_activity action: 'create', params: {owner_type: 'User', owner_id: update.user_id}
			#Check if this is a valid update
			#Video but not youtube or vimeo
			if update.post_type == "video" then
				if update.caption == "youtube.com" || update.caption == "vimeo.com" then
					#valid
				else
					#invalid
					update.update_column(:valid_update,false)
					activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(update.id,'Facebookupdate')
					if activity != nil then
						activity.deleted = true
						activity.deleted_at = Time.now
						activity.save
					end
				end
			end
			#photo without message
			if update.post_type == "photo" then
				if update.message == nil then
					#invalid
					update.update_column(:valid_update,false)
					activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(update.id,'Facebookupdate')
					if activity != nil then
						activity.deleted = true
						activity.deleted_at = Time.now
						activity.save
					end					
				else
					#valid
				end
			end
			#milestone
			if update.post_type == "status" && update.message == "This is a milestone." then
				#invalid
				update.update_column(:valid_update,false)
				activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(update.id,'Facebookupdate')
				if activity != nil then
					activity.deleted = true
					activity.deleted_at = Time.now
					activity.save
				end				
			else
				#valid
			end
			#Without story, without message, without description
			if update.message == nil && update.description == nil then
				#invalid
				update.update_column(:valid_update,false)
				activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(update.id,'Facebookupdate')
				if activity != nil then
					activity.deleted = true
					activity.deleted_at = Time.now
					activity.save
				end					
			end

		end
 	end 

	def self.real_time_update!(payload)
	    RealtimeUpdate.new(payload).enqueue_updates!
	end

	has_attached_file :facebookimage, :styles => {:preview => ["790", :jpg], :thumbnail => ["171x96#",:jpg]}, :convert_options => { :all => '-background "#c8c8c8" -flatten +matte'},
	:default_url => "/assets/projecticon_:style.jpg",
	      :url =>  "/:class/uploads/:id/:style/:escaped_filename2",
      #If s3
      :path => "/:class/uploads/:id/:style/:escaped_filename2",
      :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/s3_profile.yml"
	
	Paperclip.interpolates :escaped_filename2 do |attachment, style|
		attachment.instance.normalized_profile_file_name
	end    

	def normalized_profile_file_name
		"#{self.id}-#{self.facebookimage_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
	end	 

 
	class RealtimeUpdate < Struct.new(:payload)
 
    	def enqueue_updates!
      		remove_duplicate_uids.each do |entry|
      			#This is to find the user
        		if (facebookpage = Facebookpage.find_by_page_id(entry['uid']).try(:facebookpage))
        			if facebookpage.sync == true then 
          				Resque.enqueue(FacebookupdateWorker, facebookpage.page_id)
          			end
        		end
      		end
   	 	end
 
	protected
 
    	def remove_duplicate_uids
     		payload['entry'].each_with_object({}) do |entry, hash|
        		hash[entry['uid']] ||= [] << entry
      		end.values.collect { |update_payloads| update_payloads.min { |entry1, entry2| entry1['time']<=>entry2['time'] } }
    	end
 
  	end

end
