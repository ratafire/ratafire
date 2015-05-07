class FacebookupdateAllWorker

	@queue = :facebookupdate_all_queue

	def self.perform(page_id)
		#Connect to Facebook graph
		facebookpage = Facebookpage.find_by_page_id(page_id)
		if facebookpage != nil then 
			@page_graph = Koala::Facebook::API.new(facebookpage.access_token)
			posts = @page_graph.get_connection(page_id, 'posts',{type: 'large'})
			if posts != nil then 
				posts.each do |post|
					if post["from"]["id"] == page_id then
						Facebookupdate.create_facebookupdate(post,facebookpage.user_id,facebookpage.id,facebookpage.facebook_id,page_id)
					end
				end
			end
		end
	end

end