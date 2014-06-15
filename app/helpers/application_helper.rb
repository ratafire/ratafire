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
		if @user.subscription_switch == true && @user.amazon_authorized == true && @user.why != nil && @user.plan != nil && @user.subscription_amount < @user.goals_monthly && @project != nil then
			if @user.facebook != nil || @user.github != nil then
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

	#Video true or Artwork true
	def video_true_or_artwork_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id != nil && activity.video_id != "" then
			return true
		else
			if activity.artwork != nil then
				return true
			else
				return false
			end
		end
	end

	#Video true and Artwork false
	def video_true_and_artwork_false(project_id)
		activity = Project.find(project_id)
		if activity.video_id != nil && activity.video_id != "" then
			if activity.artwork == nil then
				return true
			else
				return false	
			end
		else
			return false	
		end
	end

	#Video false and Artwork true
	def video_false_and_artwork_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id == nil || activity.video_id == "" then
			if activity.artwork != nil then
				return true
			else
				return false	
			end
		else
			return false	
		end		
	end

	#Video true and artwork true
	def video_true_and_artwork_true(project_id)
		activity = Project.find(project_id)
		if activity.video_id != nil && activity.video_id != "" then
			if activity.artwork != nil then
				return true
			else
				return false
			end	
		else
			return false	
		end
	end


end
