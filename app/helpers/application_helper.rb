module ApplicationHelper

	include ActsAsTaggableOn::TagsHelper

#------------------------ Essentials ------------------------

	#Returns the full title on a per-page basis
	def full_title(page_title)
		base_title = "Ratafire"
		if page_title.empty?
			base_title
		else
			"#{base_title} - #{page_title}"
		end
	end

#------------------------ Users -----------------------------

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

#------------------------ Content -----------------------------

	#Determine how the image grid is shown
	def image_grid(count)
		case count
		when 1
			return "1"
		when 2
			return "11"
		when 3
			return "12"
		when 4
			return "22"
		when 5
			return "23"
		when 6
			return "33"
		when 7
			return "223"
		when 8
			return "233"
		when 9
			return "333"
		else
			return "3333333333333333333333333333333333333333333333333"
		end
	end

end
