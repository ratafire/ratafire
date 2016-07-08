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
		when 'Science'
			return 'views.utilities.menu.is_researching'
		when 'Humanity'
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
		when 'Science'
			return 'views.utilities.menu.science'
		when 'Humanity'
			return 'views.utilities.menu.humanity'
		when 'Engineering'
			return 'views.utilities.menu.engineering'
		end
	end

	#Get category color
	def category_color(category)
		case category
		when 'Art'
			return 'bg-blue'
		when 'Music'
			return 'bg-green'
		when 'Games'
			return 'bg-pink'
		when 'Writing'
			return 'bg-violet'
		when 'Videos'
			return 'bg-indigo'
		when 'Math'
			return 'bg-orange'
		when 'Science'
			return 'bg-brown'
		when 'Humanity'
			return 'bg-purple'
		when 'Engineering'
			return 'bg-slate'
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
		when 'Science'
			return 'views.utilities.editor.get_paid_for_this_research'
		when 'Humanity'
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
		when 'Science'
			return 'views.utilities.editor.paid_research'
		when 'Humanity'
			return 'views.utilities.editor.paid_research'
		when 'Engineering'
			return 'views.utilities.editor.paid_development'
		else
			return 'views.utilities.editor.paid_update'
		end
	end

	def currency_signs(currency)
		case currency
		when 'aud'
			return 'AU$'
		when 'eur'
			return '€'
		when 'cad'
			return 'C$'
		when 'usd'
			return '$'
		end
	end

	def days_to_current_goal(due)
		days = (due.to_date - Time.now.to_date).to_i
		if days >= 0 
			return days
		else
			return 0
		end
	end

	def shipping(shipping_method)
		case shipping_method
		when 'no'
			return 'views.campaign.reward_shipping_no'
		when 'some'
			return 'views.campaign.reward_shipping_some'
		when 'anywhere'
			return 'views.campaign.reward_shipping_anywhere'
		end
	end

	def majorpost_fullurl(majorpost_uuid)
		if Rails.env.production?
			return 'https://ratafire.com/content/majorposts/'+majorpost_uuid
		else
			return 'http://localhost:3000/content/majorposts/'+majorpost_uuid
		end
	end

	def is_liker?(user_id, content_type, content_id)
		case content_type
		when 'Campaign' 
			if LikedCampaign.find_by_campaign_id_and_user_id(content_id,user_id)
				return true
			else
				return false
			end
		when 'Majorpost'
			if LikedMajorpost.find_by_majorpost_id_and_user_id(content_id,user_id)
				return true
			else
				return false
			end
		when 'User'
			if LikedUser.find_by_liked_id_and_liker_id(content_id, user_id)
				return true
			else
				return false
			end
		end
	end

	def bootstrap_class_for(flash_type)
		case flash_type
		when 'success'
		"rainbow-800 bg-success transparent-border"
		when 'error'
		"rainbow-400 bg-danger transparent-border"
		when 'alert'
		"rainbow-700 bg-warning transparent-border"
		when 'notice'
		"rainbow-600 bg-info transparent-border"
		else
		flash_type.to_s
		end
	end	

end
