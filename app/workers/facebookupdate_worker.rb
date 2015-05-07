class FacebookupdateWorker

	@queue = :facebookupdate_queue

	def self.perform(page_id)
		#Connect to Facebook graph
		facebookpage = Facebookpage.find_by_page_id(page_id)
		if facebookpage != nil then 
			@page_graph = Koala::Facebook::API.new(facebookpage.access_token)
			posts = @page_graph.get_connection(page_id, 'posts',{limit: 3, type: 'large'})
			if posts != nil then 
				count = 0
				posts.each do |post|
					if post["from"]["id"] == page_id then
						Facebookupdate.create_facebookupdate(post,facebookpage.user_id,facebookpage.id,facebookpage.facebook_id,page_id)
						count+=1
					end
				end
				if count < 1 then
					posts = @page_graph.get_connection(page_id, 'posts',{limit: 10, type: 'large'})
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
	end

end