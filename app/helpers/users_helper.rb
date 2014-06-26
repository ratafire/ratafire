module UsersHelper

	#Early Access Title
	def early_access?(majorpost_id)
		if user_signed_in? then
			major_post = Majorpost.find(majorpost_id)
			user = major_post.user
			@subscription = Subscription.where(:deleted => false, :activated => true, :subscriber_id => current_user.id, :subscribed_id => user.id).first
			if @subscription != nil then
				#current_user is subscribed to activity.trackable.user
				diff = ((major_post.published_at+6.days-Time.now)/1.day).to_i
				#current_user is subscribed to @user
				case @subscription.amount
				when ENV["PRICE_1"].to_f
					return false
				when ENV["PRICE_2"].to_f
					unless diff < 2 then
						return false
					else
						return true
					end
				when ENV["PRICE_3"].to_f
					unless diff < 3 then
						return false
					else
						return true
					end				
				when ENV["PRICE_4"].to_f
					unless diff < 4 then
						return false
					else
						return true
					end						
				when ENV["PRICE_5"].to_f
					unless diff < 5 then
						return false
					else
						return true
					end					
				when ENV["PRICE_6"].to_f
					return true			
				end	
			else
				if major_post.project.users.map(&:id).include? current_user.id then
					return true
				else
					return false
				end
			end
		else
			return false
		end
	end

	#Early Access Date
	def early_access(majorpost_id)
		major_post = Majorpost.find(majorpost_id)
		@user = major_post.user
		#Check if current_user is subscribed to @user
		#First check if the user is on @user's profile page
		if @subscription != nil then
			diff = ((major_post.published_at+6.days-Time.now)/1.day).to_i
			#current_user is subscribed to @user
			case @subscription.amount
			when ENV["PRICE_1"].to_f
				return link_to "Subscribe to #{@user.fullname}",@user, class:"no_ajaxify" +"to get early access."
			when ENV["PRICE_2"].to_f
				unless diff < 2 then
					diff_day = distance_of_time_in_words(Time.now,major_post.published_at+4.days)
					return "Your 2-day early access starts in "+diff_day+"!"
				else
					return "You have 2-day early access!"
				end
			when ENV["PRICE_3"].to_f
				unless diff < 3 then
					diff_day = distance_of_time_in_words(Time.now,major_post.published_at+3.days)
					return "Your 3-day early access starts in "+diff_day+"!"
				else
					return "You have 3-day early access!"
				end				
			when ENV["PRICE_4"].to_f
				unless diff < 4 then
					diff_day = distance_of_time_in_words(Time.now,major_post.published_at+2.days)
					return "Your 4-day early access starts in "+diff_day+"!"
				else
					return "You have 4-day early access!"
				end						
			when ENV["PRICE_5"].to_f
				unless diff < 5 then
					diff_day = distance_of_time_in_words(Time.now,major_post.published_at+1.days)			
					return "Your 5-day early access starts in "+diff_day+"!"
				else
					return "You have 5-day early access!"
				end					
			when ENV["PRICE_6"].to_f
				return "You have 6-day early access!"					
			end	
		else
			#Check again if current_user is subscribed to @user
			if user_signed_in? then
				@subscription = Subscription.where(:deleted => false, :activated => true, :subscriber_id => current_user.id, :subscribed_id => @user.id).first
				if @subscription != nil then
					#current_user is subscribed to activity.trackable.user
					diff = ((major_post.published_at+6.days-Time.now)/1.day).to_i
					#current_user is subscribed to @user
					case @subscription.amount
					when ENV["PRICE_1"].to_f
						return link_to "Subscribe to #{@user.fullname} to get early access.",why_path(@user), class:"no_ajaxify"
					when ENV["PRICE_2"].to_f
						unless diff < 2 then
							diff_day = distance_of_time_in_words(Time.now,major_post.published_at+4.days)
							return "Your 2-day early access starts in "+diff_day+"!"
						else
							return "You have 2-day early access!"
						end
					when ENV["PRICE_3"].to_f
						unless diff < 3 then
							diff_day = distance_of_time_in_words(Time.now,major_post.published_at+3.days)
							return "Your 3-day early access starts in "+diff_day+"!"
						else
							return "You have 3-day early access!"
						end				
					when ENV["PRICE_4"].to_f
						unless diff < 4 then
							diff_day = distance_of_time_in_words(Time.now,major_post.published_at+2.days)
							return "Your 4-day early access starts in "+diff_day+"!"
						else
							return "You have 4-day early access!"
						end						
					when ENV["PRICE_5"].to_f
						unless diff < 5 then
							diff_day = distance_of_time_in_words(Time.now,major_post.published_at+1.days)			
							return "Your 5-day early access starts in "+diff_day+"!"
						else
							return "You have 5-day early access!"
						end					
					when ENV["PRICE_6"].to_f
						return "You have 6-day early access!"				
					end	
				else
					#Check if user is project owner
					if major_post.project.users.map(&:id).include? current_user.id then
						return "You have early access!"
					else
						return link_to "Subscribe to #{@user.fullname} to get early access.",why_path(@user), class:"no_ajaxify"
					end
				end
			else
				return link_to "Subscribe to #{@user.fullname} to get early access.",why_path(@user), class:"no_ajaxify"
			end
		end
	end

end
