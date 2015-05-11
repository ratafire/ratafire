class Facebookpost < ActiveRecord::Base

	#Post to Facebook 
	def self.post_to_facebook(user_id,object_type,object_id,options = {})
		link_url = Rails.env.production? ? "https://www.ratafire.com/" : "http://localhost:3000/"
		user = User.find(user_id)
		if user != nil && user.facebook != nil then
			if user.facebook.post_access_token != nil then 
				case object_type
				when "work_collection"
					project = Project.find(object_id)
					if project != nil then 
						excerpt = project.excerpt.gsub("\r","").gsub(/\n\s+/, "\r\n\r\n")
						begin
							@graph = Koala::Facebook::API.new(user.facebook.post_access_token)
							if @graph != nil then 
								#If the post has a video
								if project.video != nil then
									#If internal video
									if project.video.external == nil then
										response = @graph.put_wall_post(excerpt, attachment = {
											"name" => project.title, 
											"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
											"description" => project.tagline,
											"picture" => project.video.thumbnail.url
										},user.facebook.uid)
										project.update_column(:facebookupdate_id, response["id"])
									else
										#Youtube or Vimeo video
										excerpt = excerpt+"\r\n\r\nSupport #{user.fullname} at "+link_url+"#{project.creator.username}/#{project.perlink}/."
										response = @graph.put_wall_post(excerpt, attachment = {
											"link" => project.video.direct_upload_url
										},user.facebook.uid)	
										project.update_column(:facebookupdate_id, response["id"])								
									end
								else
									if project.audio != nil then
										if project.audio.soundcloud != nil then
											#Soundcloud audio
											excerpt = excerpt+"\r\n\r\nSupport #{user.fullname} at "+link_url+"#{project.creator.username}/#{project.perlink}/."
											response = @graph.put_wall_post(excerpt, attachment = {
												"link" => project.audio.direct_upload_url
											},user.facebook.uid)	
											project.update_column(:facebookupdate_id, response["id"])
										else
											#If the post has images
											if project.projectimages.count > 0 then
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => project.title, 
													"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
													"description" => project.tagline,
													"picture" => project.projectimages.first.url
												},user.facebook.uid)
												project.update_column(:facebookupdate_id, response["id"])
											else
												#If the project has nothing
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => project.title, 
													"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
													"description" => project.tagline,
													"picture" => project.icon.image.url
												},user.facebook.uid)	
												project.update_column(:facebookupdate_id, response["id"])																								
											end
										end
									else
										#Internal audio
										if project.artwork != nil then
											#If the post has an artwork	
											response = @graph.put_wall_post(excerpt, attachment = {
												"name" => project.title, 
												"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
												"description" => project.tagline,
												"picture" => project.artwork.image.url
											},user.facebook.uid)		
											project.update_column(:facebookupdate_id, response["id"])									
										else
											#If the post has images
											if project.projectimages.count > 0 then
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => project.title, 
													"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
													"description" => project.tagline,
													"picture" => project.projectimages.first.url
												},user.facebook.uid)
												project.update_column(:facebookupdate_id, response["id"])
											else
												#If the project has nothing
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => project.title, 
													"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
													"description" => project.tagline,
													"picture" => project.icon.image.url
												},user.facebook.uid)	
												project.update_column(:facebookupdate_id, response["id"])																								
											end
										end
									end
								end
							end
						rescue Koala::Facebook::APIError => exc
							logger.error("Problems posting to Facebook Wall..."+self.id+" at project: "+project.id)
						end
					end
				when "majorpost"
					majorpost = Majorpost.find(object_id)
					excerpt = majorpost.excerpt.gsub("\r","").gsub(/\n\s+/, "\r\n\r\n")
					if majorpost != nil then 
						begin
							@graph = Koala::Facebook::API.new(user.facebook.post_access_token)
							if @graph != nil then 
								#If the post has a video
								if majorpost.video != nil then
									#If internal video
									if majorpost.video.external == nil then
										response = @graph.put_wall_post(excerpt, attachment = {
											"name" => majorpost.title, 
											"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
											"description" => "From work collection - "+majorpost.project.title,
											"picture" => majorpost.video.thumbnail.url
										},user.facebook.uid)
										majorpost.update_column(:facebookupdate_id, response["id"])
									else
										#Youtube or Vimeo video
										excerpt = excerpt+"\r\n\r\nSupport #{user.fullname} at "+link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}."
										response = @graph.put_wall_post(excerpt, attachment = {
											"link" => majorpost.video.direct_upload_url
										},user.facebook.uid)	
										majorpost.update_column(:facebookupdate_id, response["id"])								
									end
								else
									if majorpost.audio != nil then
										if majorpost.audio.soundcloud != nil then
											#Soundcloud audio
											excerpt = excerpt+"\r\n\r\nSupport #{user.fullname} at "+link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}."
											response = @graph.put_wall_post(excerpt, attachment = {
												"link" => majorpost.audio.direct_upload_url
											},user.facebook.uid)	
											majorpost.update_column(:facebookupdate_id, response["id"])
										else
											#If the project has nothing
											if majorpost.project.icon != nil then 
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => majorpost.title, 
													"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
													"description" => "From work collection - "+majorpost.project.title,
													"picture" => majorpost.project.icon.image.url
												},user.facebook.uid)	
												majorpost.update_column(:facebookupdate_id, response["id"])	
											else
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => majorpost.title, 
													"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
												},user.facebook.uid)	
												majorpost.update_column(:facebookupdate_id, response["id"])															
											end												
										end
									else
										#Internal audio
										if majorpost.artwork != nil then
											#If the post has an artwork	
											response = @graph.put_wall_post(excerpt, attachment = {
												"name" => majorpost.title, 
												"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
												"description" => "From work collection - "+majorpost.project.title,
												"picture" => majorpost.artwork.image.url
											},user.facebook.uid)		
											majorpost.update_column(:facebookupdate_id, response["id"])									
										else
											#If the post has images
											if majorpost.postimages.count > 0 then
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => majorpost.title, 
													"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
													"description" => "From work collection - "+majorpost.project.title,
													"picture" => majorpost.postimages.first.url
												},user.facebook.uid)
												majorpost.update_column(:facebookupdate_id, response["id"])
											else
												#If the project has nothing
												if majorpost.project.icon != nil then 
													response = @graph.put_wall_post(excerpt, attachment = {
														"name" => majorpost.title, 
														"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
														"description" => "From work collection - "+majorpost.project.title,
														"picture" => majorpost.project.icon.image.url
													},user.facebook.uid)	
													majorpost.update_column(:facebookupdate_id, response["id"])	
												else
													response = @graph.put_wall_post(excerpt, attachment = {
														"name" => majorpost.title, 
														"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
													},user.facebook.uid)	
													majorpost.update_column(:facebookupdate_id, response["id"])															
												end																							
											end
										end
									end
								end
							end
						rescue Koala::Facebook::APIError => exc
							logger.error("Problems posting to Facebook Wall, at majorpost: "+majorpost.id)
						end		
					end							
				when "discussion"
				end	
			end
		end
	end

	#Post to Facebook Page
	def self.post_to_facebook_page(page_id,object_type,object_id,options = {})
		facebook_page = FacebookPage.find_by_page_id(page_id)
		link_url = Rails.env.production? ? "https://www.ratafire.com/" : "http://localhost:3000/"
		if facebook_page != nil then
			case object_type
			when "work_collection"
				project = Project.find(object_id)
				excerpt = project.excerpt.gsub("\r","").gsub(/\n\s+/, "\r\n\r\n")
				begin
					@graph = Koala::Facebook::API.new(facebook_page.access_token)
					if @graph != nil then 
						#If the post has a video
						if project.video != nil then
							#If internal video
							if project.video.external == nil then
								response = @graph.put_wall_post(excerpt, attachment = {
									"name" => project.title, 
									"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
									"description" => project.tagline,
									"picture" => project.video.thumbnail.url
								},facebook_page.page_id)
								project.update_column(:facebookupdate_id, response["id"])
							else
								#Youtube or Vimeo video
								excerpt = excerpt+"\r\n\r\nSupport #{user.fullname} at "+link_url+"#{project.creator.username}/#{project.perlink}/."
								response = @graph.put_wall_post(excerpt, attachment = {
									"link" => project.video.direct_upload_url
								},facebook_page.page_id)	
								project.update_column(:facebookupdate_id, response["id"])								
							end
						else
							if project.audio != nil then
								if project.audio.soundcloud != nil then
									#Soundcloud audio
									excerpt = excerpt+"\r\n\r\nSupport #{user.fullname} at "+link_url+"#{project.creator.username}/#{project.perlink}/."
									response = @graph.put_wall_post(excerpt, attachment = {
										"link" => project.audio.direct_upload_url
									},facebook_page.page_id)	
									project.update_column(:facebookupdate_id, response["id"])
								else
									#If the post has images
									if project.projectimages.count > 0 then
										response = @graph.put_wall_post(excerpt, attachment = {
											"name" => project.title, 
											"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
											"description" => project.tagline,
											"picture" => project.projectimages.first.url
										},facebook_page.page_id)
										project.update_column(:facebookupdate_id, response["id"])
									else
										#If the project has nothing
										response = @graph.put_wall_post(excerpt, attachment = {
											"name" => project.title, 
											"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
											"description" => project.tagline,
											"picture" => project.icon.image.url
										},facebook_page.page_id)	
										project.update_column(:facebookupdate_id, response["id"])																								
									end
								end
							else
								#Internal audio
								if project.artwork != nil then
									#If the post has an artwork	
									response = @graph.put_wall_post(excerpt, attachment = {
										"name" => project.title, 
										"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
										"description" => project.tagline,
										"picture" => project.artwork.image.url
									},facebook_page.page_id)		
									project.update_column(:facebookupdate_id, response["id"])									
								else
									#If the post has images
									if project.projectimages.count > 0 then
										response = @graph.put_wall_post(excerpt, attachment = {
											"name" => project.title, 
											"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
											"description" => project.tagline,
											"picture" => project.projectimages.first.url
										},facebook_page.page_id)
										project.update_column(:facebookupdate_id, response["id"])
									else
										#If the project has nothing
										response = @graph.put_wall_post(excerpt, attachment = {
											"name" => project.title, 
											"link" => link_url+"#{project.creator.username}/#{project.perlink}/",
											"description" => project.tagline,
											"picture" => project.icon.image.url
										},facebook_page.page_id)	
										project.update_column(:facebookupdate_id, response["id"])																								
									end
								end
							end
						end
					end
				rescue Koala::Facebook::APIError => exc
					logger.error("Problems posting to Facebook Wall, at project: "+project.id)
				end				
			when "majorpost"
				majorpost = Majorpost.find(object_id)
				excerpt = majorpost.excerpt.gsub("\r","").gsub(/\n\s+/, "\r\n\r\n")
				if majorpost != nil then 
					begin
						@graph = Koala::Facebook::API.new(facebook_page.access_token)
						if @graph != nil then 
							#If the post has a video
							if majorpost.video != nil then
								#If internal video
								if majorpost.video.external == nil then
									response = @graph.put_wall_post(excerpt, attachment = {
										"name" => majorpost.title, 
										"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
										"description" => "From work collection - "+majorpost.project.title,
										"picture" => majorpost.video.thumbnail.url
									},facebook_page.page_id)
									majorpost.update_column(:facebookupdate_id, response["id"])
								else
									#Youtube or Vimeo video
									excerpt = excerpt+"\r\n\r\nSupport #{user.fullname} at "+link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}."
									response = @graph.put_wall_post(excerpt, attachment = {
										"link" => majorpost.video.direct_upload_url
									},facebook_page.page_id)	
									majorpost.update_column(:facebookupdate_id, response["id"])								
								end
							else
								if majorpost.audio != nil then
									if majorpost.audio.soundcloud != nil then
										#Soundcloud audio
										excerpt = excerpt+"\r\n\r\nSupport #{user.fullname} at "+link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}."
										response = @graph.put_wall_post(excerpt, attachment = {
											"link" => majorpost.audio.direct_upload_url
										},facebook_page.page_id)	
										majorpost.update_column(:facebookupdate_id, response["id"])
									else
										#If the project has nothing
										if majorpost.project.icon != nil then 
											response = @graph.put_wall_post(excerpt, attachment = {
												"name" => majorpost.title, 
												"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
												"description" => "From work collection - "+majorpost.project.title,
												"picture" => majorpost.project.icon.image.url
											},facebook_page.page_id)	
											majorpost.update_column(:facebookupdate_id, response["id"])	
										else
											response = @graph.put_wall_post(excerpt, attachment = {
												"name" => majorpost.title, 
												"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
											},facebook_page.page_id)	
											majorpost.update_column(:facebookupdate_id, response["id"])															
										end											
									end
								else
									#Internal audio
									if majorpost.artwork != nil then
										#If the post has an artwork	
										response = @graph.put_wall_post(excerpt, attachment = {
											"name" => majorpost.title, 
											"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
											"description" => "From work collection - "+majorpost.project.title,
											"picture" => majorpost.artwork.image.url
										},facebook_page.page_id)		
										majorpost.update_column(:facebookupdate_id, response["id"])									
									else
										#If the post has images
										if majorpost.postimages.count > 0 then
											response = @graph.put_wall_post(excerpt, attachment = {
												"name" => majorpost.title, 
												"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
												"description" => "From work collection - "+majorpost.project.title,
												"picture" => majorpost.postimages.first.url
											},facebook_page.page_id)
											majorpost.update_column(:facebookupdate_id, response["id"])
										else
											#If the project has nothing
											if majorpost.project.icon != nil then 
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => majorpost.title, 
													"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
													"description" => "From work collection - "+majorpost.project.title,
													"picture" => majorpost.project.icon.image.url
												},facebook_page.page_id)	
												majorpost.update_column(:facebookupdate_id, response["id"])	
											else
												response = @graph.put_wall_post(excerpt, attachment = {
													"name" => majorpost.title, 
													"link" => link_url+"#{majorpost.project.creator.username}/#{majorpost.project.perlink}/#{majorpost.perlink}",
												},facebook_page.page_id)	
												majorpost.update_column(:facebookupdate_id, response["id"])															
											end																							
										end
									end
								end
							end
						end
					rescue Koala::Facebook::APIError => exc
						logger.error("Problems posting to Facebook Wall, at majorpost: "+majorpost.id)
					end	
				end					
			when "discussion"
			end
		end
	end

end

