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

end
