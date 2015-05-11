class FacebookPostWorker

	@queue = :facebook_post_queue

	def self.perform(user_id,object_type,object_id,options = {})
		if options[:post_to_page] == true then
			#Post to Page
			facebook_page = uesr.facebook_pages.first
			if facebook_page != nil then 
				Facebookpost.post_to_facebook_page(facebook_page.page_id,object_type,object_id)
			end
		else
			if options[:post_to_both] == true then
				facebook_page = uesr.facebook_pages.first
				if facebook_page != nil then 
					Facebookpost.post_to_facebook_page(facebook_page.page_id,object_type,object_id)
					Facebookpost.post_to_facebook(user_id, object_type,object_id)
				else
					Facebookpost.post_to_facebook(user_id, object_type,object_id)
				end
			else
				#Post to Personal Feed
				Facebookpost.post_to_facebook(user_id, object_type,object_id)
			end
		end
	end

end
