module ApplicationHelper

	include ActsAsTaggableOn::TagsHelper

	# Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "Ratafire"
		if page_title.empty?
			base_title
		else
			"#{base_title} - #{page_title}"
		end
	end

	#Devise 
    def current_user?(user)
      user == current_user
    end

    #User Tagline Default
  	def user_tagline_default
  		tagline = "Sits down at the fire of Ratatoskr"
  		return tagline
  	end

  	#See if a user is an assigned_user of a project
	def assigned_user
		if signed_in?
			@current_user_id = current_user.id
			@project.users.map(&:id).include?(@current_user_id)
		else
			false
		end
	end

	#Find activity user
	def user_profile_photo_64(user_id)
		u = User.find(user_id)
		return u.profilephoto.url(:small64)
	end

	#Find current user id
	def current_user_id(current_user)
		return current_user.id.to_i
	end

	#Find subscription for project
	def subscription_project(project_id)
		return Project.find(project_id)
	end

	#Get Wikipedia first sentence
	def wikipedia(title)
		if title.split(" ")[1] != nil then
			query = title.gsub(/\s/, "%20")
		else
			query = title
		end	
		query = query.downcase.capitalize
		result = open("http://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles="+query).read.to_s.split("\"extract\":\"")[1]
		if result != nil && result.length > 200 then
			sentence = Sanitize.clean(result.split(".")[0]+"...").strip.gsub("\\n", "-").gsub(/\([^()]*\)/, "")
			if sentence =~ /This is a redirect from a title with another method of capitalisation/ || result.length < 200 then
				query = title.titleize.gsub(/\s/, "%20")
				result = open("http://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles="+query).read.to_s.split("\"extract\":\"")[1]
				sentence = Sanitize.clean(result.split(".")[0]+"...").strip.gsub("\\n", "-").gsub(/\([^()]*\)/, "")
				if sentence =~ /This is a redirect from a title with another method of capitalisation/ || result.length < 200 then
					sentence = "Projects and major posts in " + title + "."
				end	
			end
			if sentence =~ /may refer to/ then
				sentence = "Projects and major posts in " + title + "."
			end
			return sentence
		else
			sentence = "Projects and major posts in " + title + "."
			return sentence
		end	
	end

	#Get Wikipedia first sentence
	def wikipedia_search(title)
		if title.split(" ")[1] != nil then
			query = title.gsub(/\s/, "%20")
		else
			query = title
		end	
		query = query.downcase.capitalize
		result = open("http://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles="+query).read.to_s.split("\"extract\":\"")[1]
		if result != nil && result.length > 200 then
			sentence = Sanitize.clean(result.split(".")[0]+"...").strip.gsub("\\n", "-").gsub(/\([^()]*\)/, "")
			if sentence =~ /This is a redirect from a title with another method of capitalisation/ || result.length < 200 then
				query = title.titleize.gsub(/\s/, "%20")
				result = open("http://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles="+query).read.to_s.split("\"extract\":\"")[1]
				sentence = Sanitize.clean(result.split(".")[0]+"...").strip.gsub("\\n", "-").gsub(/\([^()]*\)/, "")
				if sentence =~ /This is a redirect from a title with another method of capitalisation/ || result.length < 200 then
					sentence = "Search result of " + title + "."
				end	
			end
			if sentence =~ /may refer to/ then
				sentence = "Search result of " + title + "."
			end
			return sentence
		else
			sentence = "Search result of " + title + "."
			return sentence
		end	
	end	

	#Comment liked button
	def liked_comment(commentid)
		if LikedComment.find_by_comment_id_and_user_id(commentid,current_user.id) != nil then
			return true
		else
			return false
		end
	end	

	#Subscription Status
	

#Edit permissions----------------------
	
	#Project edit
	def project_edit(project)
		if project.creator == current_user then
			if project.edit_permission == "edit" || project.edit_permission == "free" then
				return true
			else
				return false	
			end
		else
			if user_signed_in? then
				if current_user.admin? then
					return true
				else
					return false
				end	
			else
				return false
			end
		end
	end

	def project_header_edit(project)
		if project.creator == current_user then
			if @project.abandoned != true then
				return true 
			else
				return false
			end
		else
			if user_signed_in? then
				if current_user.admin? then 
					return true
				else
					return false
				end
			else
				return false
			end
		end
	end

	#Project edit
	def project_edit_everyone(project)
		if assigned_user && project.flag == false then
			if project.edit_permission == "edit" || project.edit_permission == "free" then
				return true
			else
				return false	
			end
		end
	end

	#Project delete
	def project_delete(project)
		if project.creator == current_user then
			if project.edit_permission == "free" then
				return true
			else
				return false	
			end
		end
	end

	#Majorpost edit
	def majorpost_edit(majorpost)
		if majorpost.user == current_user then
			if majorpost.project.edit_permission != "frozen" then
				if majorpost.project.edit_permission == "edit" then
					if majorpost.edit_permission == "edit" || majorpost.edit_permission == "free" then
						return true
					else
						return false
					end
				else
					return false #project.edit_permission == "free"
				end
			else
				return false #project.edit_permission == "frozen"
			end
		end	
	end

	#Majorpost delete
	def majorpost_delete(majorpost)
		if majorpost.user == current_user then
			if majorpost.project.edit_permission != "frozen" then
				if majorpost.project.edit_permission == "edit" then
					if majorpost.edit_permission == "free" then
						return true
					else
						return false
					end
				else
					return false #project.edit_permission == "free"
				end
			else
				return false #project.edit_permission == "frozen"
			end
		end	
	end

	#Discussion Edit
	def discussion_edit(discussion)
		if discussion.creator == current_user then
			if discussion.edit_permission == "edit" || discussion.edit_permission == "free" then
				if discussion.published == true && discussion.reviewed_at == nil then
					return false
				else
					return true
				end
			else
				return false	
			end
		else
			if user_signed_in? then
				if current_user.admin? then
					return true
				else
					return false
				end	
			else
				return false
			end
		end
	end	

	#Discussion delete
	def discussion_delete(discussion)
		if discussion.creator == current_user then
			if discussion.edit_permission == "free" then
				return true
			else
				return false	
			end
		else 
			if user_signed_in? then
				if current_user.admin? then
					return true
				else
					return false
				end
			else
				return false
			end 
		end
	end

	#Discussion Thread Edit
	def discussion_thread_edit(discussion_thread)
		if discussion_thread.creator == current_user || @discussion.creator == current_user then
			if discussion_thread.edit_permission == "free" then
				return true
			else
				return false	
			end
		else 
			if user_signed_in? then
				if current_user.admin? then
					return true
				else
					return false
				end
			else
				return false
			end 
		end
	end


	#Project realms
	def project_realm(projectrealm)
		case projectrealm
		when "art"
			return "Art"
		when "music"
			return "Music"
		when "games"
			return "Games"
		when "writing"
			return "Writing"
		when "videos"
			return "Films & Videos"
		when "math"
			return "Math"
		when "science"
			return "Research: Science"
		when "humanity"
			return "Research: Humanity"
		when "engineering"
			return "Engineering"
		end
	end

	#Project realms BG
	def project_realm_bg(projectrealm)
		case projectrealm
		when "art"
			return "/assets/water_art.png"
		when "music"
			return "/assets/water_music.png"
		when "games"
			return "/assets/water_games.png"
		when "writing"
			return "/assets/water_writing.png"
		when "videos"
			return "/assets/water_video.png"
		when "math"
			return "/assets/water_math.png"
		when "science"
			return "/assets/water_apple.png"
		when "humanity"
			return "/assets/water_humanity.png"
		when "engineering"
			return "/assets/water_engineering.png"
		end
	end
	#Project realms css
	def project_realm_css(projectrealm)
		case projectrealm
		when "art"
			return "realm-art"
		when "music"
			return "realm-music"
		when "games"
			return "realm-games"
		when "writing"
			return "realm-writing"
		when "videos"
			return "realm-videos"
		when "math"
			return "realm-math"
		when "science"
			return "realm-science"
		when "humanity"
			return "realm-humanity"
		when "engineering"
			return "realm-engineering"
		end		
	end

	#Get realm path
	def get_realm_path(realm)
		return path = realm+"_path"
	end

	#Subscription Status
	def subscription_status
		if @user.subscription_switch == true && @user.amazon_authorized == true && @user.why != nil && @user.why != "" && @user.plan != nil && @user.plan != "" && @user.subscription_amount < @user.goals_monthly && @project != nil && @user.subscription_status_initial == "Approved" then
			if @user.facebook != nil || @user.github != nil then
				return true
			else
				return false
			end
		else
			return false
		end
	end

	#Subscription Status Universial
	def subscription_status_universial(user_id)
		user = User.find(user_id)
		project = user.projects.where(:published => true, :complete => false, :abandoned => false).first
		if user.subscription_switch == true && user.amazon_authorized == true && user.why != nil && user.why != "" && user.plan != nil && user.plan != "" && user.subscription_amount < user.goals_monthly && project != nil && user.subscription_status_initial == "Approved" then
			if user.facebook != nil || user.github != nil then
				return true
			else
				return false
			end
		else
			return false
		end
	end	

	#Subscriber Status
	def subscriber_status
		if Rails.env.production?
			if user_signed_in? && current_user.profilephoto? then
				if current_user.github != nil || current_user.facebook != nil then
					return true
				else
					return false
				end
			else
				return false
			end
		else
			return true
		end
	end

	#Create Project Activity Helpers

	#Video true or Artwork true or Audio true
	def video_true_or_artwork_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id != nil && activity.video_id != "" then
			return true
		else
			if activity.artwork_id != nil && activity.artwork_id != "" then
				return true
			else
				if activity.audio_id != nil && activity.audio_id != "" then
					return true
				else
					if activity.pdf_id != nil && activity.pdf_id != "" then
						return true
					else
						return false
					end
				end
			end
		end
	end

	#Video true and Artwork false and audio false
	def video_true_and_artwork_false(project_id)
		activity = Project.find(project_id)
		if activity.video_id != nil && activity.video_id != "" then
			if activity.artwork_id == nil || activity.artwork_id == "" then
				if activity.audio_id == nil || activity.audio_id == "" then
					return true
				else
					return false
				end
			else
				return false	
			end
		else
			return false	
		end
	end

	#Video false and Artwork true and audio false
	def video_false_and_artwork_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id == nil || activity.video_id == "" then
			if activity.artwork_id != nil && activity.artwork_id != "" then
				if activity.audio_id == nil || activity.audio_id == "" then
					return true
				else
					return false
				end
			else
				return false	
			end
		else
			return false	
		end		
	end

	#Video true and artwork true and audio false
	def video_true_and_artwork_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id != nil && activity.video_id != "" then
			if activity.artwork_id != nil && activity.artwork_id != "" then
				if activity.audio_id == nil || activity.audio_id == "" then 
					return true
				else
					return false
				end
			else
				return false
			end	
		else
			return false	
		end
	end

	#Video false and artwork false and audio true
	def video_false_and_artwork_false_and_audio_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id == nil || activity.video_id == "" then
			if activity.artwork_id == nil || activity.artwork_id == "" then
				if activity.audio_id != nil && activity.audio_id != "" then 
					return true
				else
					return false
				end
			else
				return false
			end	
		else
			return false	
		end
	end	

	#Video true and artwork false and audio true
	def video_true_and_artwork_false_and_audio_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id != nil && activity.video_id != "" then
			if activity.artwork_id == nil || activity.artwork_id == "" then
				if activity.audio_id != nil && activity.audio_id != "" then 
					return true
				else
					return false
				end
			else
				return false
			end	
		else
			return false	
		end
	end	

	#Video false and artwork true and audio true
	def video_false_and_artwork_true_and_audio_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id == nil || activity.video_id == "" then
			if activity.artwork_id != nil && activity.artwork_id != "" then
				if activity.audio_id != nil && activity.audio_id != "" then 
					return true
				else
					return false
				end
			else
				return false
			end	
		else
			return false	
		end
	end	


	#Video true and artwork true and audio true
	def video_true_and_artwork_true_and_audio_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id != nil && activity.video_id != "" then
			if activity.artwork_id != nil && activity.artwork_id != "" then
				if activity.audio_id != nil && activity.audio_id != "" then 
					return true
				else
					return false
				end
			else
				return false
			end	
		else
			return false	
		end
	end		

	#With PDF
	def pdf_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id == nil || activity.video_id == "" then
			if activity.artwork_id == nil || activity.artwork_id == "" then
				if activity.audio_id == nil || activity.audio_id == "" then 
					if activity.pdf_id != nil && activity.pdf_id != "" then
						return true
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end	
		else
			return false	
		end
	end			

	#Vimeo Thumbnail
	def vimeo_thumbnail(vimeo_id)
		response = HTTParty.get("http://www.vimeo.com/api/v2/video/"+vimeo_id+".json")
		url = response[0]["thumbnail_medium"]
		if url.split("http://")[1] then
			url = "https://"+url.split("http://")[1]
		end
		return url
	end

	#See if a user is blocked
	def message_not_blocked?(userid)
		if Blacklist.find_by_blacklister_id_and_blacklisted_id(current_user.id,userid) != nil then
			return false 
		else
			return true
		end
	end	

	#See if a user is blocked strong version
	def message_not_blocked_strong?(participant1,participant2)
        if participant1 == current_user.id then
            participant = participant2
            if Blacklist.find_by_blacklister_id_and_blacklisted_id(current_user.id,participant) != nil then
            	return false
            else
            	return true
            end
        else
            participant = participant1
            if Blacklist.find_by_blacklister_id_and_blacklisted_id(current_user.id,participant) != nil then
            	return false
            else
            	return true
            end            
        end
	end

	#Get the recipient of the conversation
	def message_recipient(recipient1,recipient2)
		if recipient1.id == current_user.id then
			return recipient2
		else
			return recipient1
		end
	end

	#Devise Signup Form
 	def resource_name
    	:user
 	end

  	def resource
    	@resource ||= User.new
 	end

  	def devise_mapping
    	@devise_mapping ||= Devise.mappings[:user]
  	end	


  	#User is ok to accept subscription
  	def user_subscription_check(user)
  		#User must has the initial approval
  		if user.subscription_status_initial == "Approved" then
  			#User must have an on going project
  			if user.projects.where(:published => true, :complete => false, :abandoned => false).first != nil then
  				return true
  			else
  				#user must have a synced facebook page
  				if user.facebookpages.first != nil then
  					return true
  				else
  					return false
  				end
  			end
  		else
  			return false
  		end
  	end

  	#Chect mutual friends
  	def check_mutual_friends(mutualfriends, user)
  		if mutualfriends != nil && user != nil then
  			if mutualfriends.count > 0 && user != current_user then
  				return true
  			else
  				return false
  			end
  		else
  			return false
  		end
  	end

end
