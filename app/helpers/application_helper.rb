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
		when 'Something'
			return 'views.utilities.menu.is_creating'
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
		when 'Something'
			return 'views.utilities.menu.something'
		when 'Engineering'
			return 'views.utilities.menu.engineering'
		end
	end

	#Get subcategory name 

	def is_sub_category(subcategory)
		case subcategory
		when 'A New Field'
			return 'views.utilities.category.a_new_field'		
		when 'Other'
			return 'views.utilities.category.other'
			#Art
		when 'Concept Art'
			return 'views.utilities.category.art.concept_art'
		when '3D Models'
			return 'views.utilities.category.art.3D_model'
		when 'Drawing'
			return 'views.utilities.category.art.drawing'
		when 'Painting'
			return 'views.utilities.category.art.painting'
		when 'Fashion'
			return 'views.utilities.category.art.fashion'
		when 'Beauty'
			return 'views.utilities.category.art.beauty'						
		when 'Architecture'
			return 'views.utilities.category.art.architecture'
		when 'Interior Design'
			return 'views.utilities.category.art.interior_design'
		when 'Photography'
			return 'views.utilities.category.art.photography'
		when 'Graphic Design'
			return 'views.utilities.category.art.graphic_design'
		when 'Sculpting'
			return 'views.utilities.category.art.sculpting'
			#Music
		when 'Composition'
			return 'views.utilities.category.music.composition'
		when 'Soundtrack'
			return 'views.utilities.category.music.soundtrack'
		when 'Rock'
			return 'views.utilities.category.music.rock'
		when 'Pop'
			return 'views.utilities.category.music.pop'
		when 'Cover'
			return 'views.utilities.category.music.cover'
		when 'Classical'
			return 'views.utilities.category.music.classical'
			#Games			
		when 'RPG'
			return 'views.utilities.category.games.rpg'
		when 'Strategy'
			return 'views.utilities.category.games.strategy'
		when 'Simulation'
			return 'views.utilities.category.games.simulation'
		when 'MMO'
			return 'views.utilities.category.games.mmo'
		when 'Action'
			return 'views.utilities.category.games.action'
		when 'Sport'
			return 'views.utilities.category.games.sport'
		when 'Adventure'
			return 'views.utilities.category.games.adventure'
			#Writing
		when 'Review'
			return 'views.utilities.category.writing.review'
		when 'Poetry'
			return 'views.utilities.category.writing.poetry'
		when 'Fantasy'
			return 'views.utilities.category.writing.fantasy'
		when 'Science Fiction'
			return 'views.utilities.category.writing.science_fiction'
		when 'Non-fiction'
			return 'views.utilities.category.writing.non_fiction'
			#Videos
		when 'Gaming'
			return 'views.utilities.category.videos.gaming'
		when 'Animation'
			return 'views.utilities.category.videos.animation'
		when 'CG'
			return 'views.utilities.category.videos.cg'
		when 'Movies'
			return 'views.utilities.category.videos.movies'
		when 'Documentary'
			return 'views.utilities.category.videos.documentary'
		when 'Tutorial'
			return 'views.utilities.category.videos.tutorial'
		when 'Storytelling'
			return 'views.utilities.category.videos.storytelling'			
			#Math
			#Science
			#Something
		when 'Something New'
			return 'views.utilities.category.something.something_new'
		when 'Something Old'
			return 'views.utilities.category.something.something_old'
			#Engineering
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
		when 'Something'
			return 'bg-purple'
		when 'Engineering'
			return 'bg-slate'
		end
	end

	#Get transfer color
	def transfer_color(transfer_status)
		case transfer_status
		when 'paid'
			return 'bg-green'
		when 'pending'
			return 'bg-orange'
		when 'in_transit'
			return 'bg-blue'
		when 'canceled'
			return 'bg-grey-100'
		when 'failed'
			return 'bg-pink'
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

	#get a 0-100 number of the % of goals
	def goals_count(a,b)
		if a != nil && b != nil then
			p = ((a.fdiv(b))*100).round(2).to_i
			return p
		else
			return 0
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

	#Transfer failues
	def transfer_failure_codes(failure_code)
		case failure_code
		when 'account_closed'
			return 'views.creator_studio.account_closed'
		when 'account_frozen'
			return 'views.creator_studio.account_frozen'
		when 'bank_account_restricted'
			return 'views.creator_studio.bank_account_restricted'
		when 'bank_ownership_changed'
			return 'views.creator_studio.bank_ownership_changed'
		when 'could_not_process'
			return 'views.creator_studio.could_not_process'
		when 'debit_not_authorized'
			return 'views.creator_studio.debit_not_authorized'
		when 'insufficient_funds'
			return 'views.creator_studio.insufficient_funds'
		when 'invalid_account_number'
			return 'views.creator_studio.invalid_account_number'
		when 'invalid_currency'
			return 'views.creator_studio.invalid_currency'
		when 'no_account'
			return 'views.creator_studio.no_account'
		when 'unsupported_card'
			return 'views.creator_studio.unsupported_card'
		end
	end

	#Transfer status
	def transfer_status(transfer_status)
		case transfer_status
		when 'paid'
			return 'views.creator_studio.transfer.paid'
		when 'pending'
			return 'views.creator_studio.transfer.pending'
		when 'in_transit'
			return 'views.creator_studio.transfer.in_transit'
		when 'canceled'
			return 'views.creator_studio.transfer.canceled'
		when 'failed'
			return 'views.creator_studio.transfer.failed'
		end
	end

end
