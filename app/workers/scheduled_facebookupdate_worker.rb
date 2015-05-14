class ScheduledFacebookupdateWorker

	@queue = :scheduled_facebookupdate_queue

	def self.perform
		Facebookpage.where(sync: true).all.each do |facebookpage|
			page_graph = Koala::Facebook::API.new(facebookpage.access_token)
			first_post = page_graph.get_connection(facebookpage.page_id, 'posts',{limit: 1, type: 'large'})
			if first_post != nil then
				if first_post[0] != nil then
					#this user's last update
					user_latest_update = facebookpage.user.facebookupdates.where(:valid_update => true).first
					if user_latest_update != nil then
						if user_latest_update.uid == first_post[0]["id"] then
							#Facebook page is not updated
						else
							#Facebook page is updated
							posts = page_graph.get_connection(facebookpage.page_id, 'posts',{limit: 20, type: 'large'})
							if posts != nil then
								posts.each do |post|
									if post["from"]["id"] == facebookpage.page_id then
										Facebookupdate.create_facebookupdate(post,facebookpage.user_id,facebookpage.id,facebookpage.facebook_id,facebookpage.page_id)
									end
								end
							end
						end
					end
				end
			end
		end
	end

end