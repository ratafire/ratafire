module ApplicationHelper

	include ActsAsTaggableOn::TagsHelper

#------------------------ Essentials ------------------------

	#Returns the full title on a per-page basis
	def full_title(page_title)
		base_title = t 'views.utilities.menu.ratafire'
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

	#Determine which word to show for the creating action
	def is_creating(category)
		case category
		when 'Art'
			return 'views.utilities.menu.is_creating'
		when 'Music'
			return 'views.utilities.menu.is_creating'
		when 'Games'
			return 'views.utilities.menu.is_developing'
		when 'Writing'
			return 'views.utilities.menu.is_writing'
		when 'Videos'
			return 'views.utilities.menu.is_creating'
		when 'Math'
			return 'views.utilities.menu.is_researching'
		when 'Research: Science'
			return 'views.utilities.menu.is_researching'
		when 'Research: Humanity'
			return 'views.utilities.menu.is_researching'
		when 'Engineering'
			return 'views.utilities.menu.is_developing'
		end
	end

	#Get category name
	def is_category(category)
		case category
		when 'Art'
			return 'views.utilities.menu.art'
		when 'Music'
			return 'views.utilities.menu.music'
		when 'Games'
			return 'views.utilities.menu.games'
		when 'Writing'
			return 'views.utilities.menu.writing'
		when 'Videos'
			return 'views.utilities.menu.videos'
		when 'Math'
			return 'views.utilities.menu.math'
		when 'Research: Science'
			return 'views.utilities.menu.science'
		when 'Research: Humanity'
			return 'views.utilities.menu.humanity'
		when 'Engineering'
			return 'views.utilities.menu.engineering'
		end
	end

	#Get paid for this creation
	def get_paid_for_this(category)
		case category
		when 'Art'
			return 'views.utilities.editor.get_paid_for_this_creation'
		when 'Music'
			return 'views.utilities.editor.get_paid_for_this_creation'
		when 'Games'
			return 'views.utilities.editor.get_paid_for_this_development'
		when 'Writing'
			return 'views.utilities.editor.get_paid_for_this_creation'
		when 'Videos'
			return 'views.utilities.editor.get_paid_for_this_creation'
		when 'Math'
			return 'views.utilities.editor.get_paid_for_this_research'
		when 'Research: Science'
			return 'views.utilities.editor.get_paid_for_this_research'
		when 'Research: Humanity'
			return 'views.utilities.editor.get_paid_for_this_research'
		when 'Engineering'
			return 'views.utilities.editor.get_paid_for_this_development'
		else
			return 'views.utilities.editor.get_paid_for_this_creation'
		end
	end

	#Get paid for this creation
	def paid_update(category)
		case category
		when 'Art'
			return 'views.utilities.editor.paid_update'
		when 'Music'
			return 'views.utilities.editor.paid_update'
		when 'Games'
			return 'views.utilities.editor.paid_development'
		when 'Writing'
			return 'views.utilities.editor.paid_update'
		when 'Videos'
			return 'views.utilities.editor.paid_update'
		when 'Math'
			return 'views.utilities.editor.paid_research'
		when 'Research: Science'
			return 'views.utilities.editor.paid_research'
		when 'Research: Humanity'
			return 'views.utilities.editor.paid_research'
		when 'Engineering'
			return 'views.utilities.editor.paid_development'
		else
			return 'views.utilities.editor.paid_update'
		end
	end

end
