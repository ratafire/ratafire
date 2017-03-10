class LevelXp < ActiveRecord::Base

    #----------------Methods----------------

    def add_score(event, user)
    	if lvel_xp = LevelXp.find(user.level)
	    	case event
	    	when "majorpost"
	    		user.add_points(lvel_xp.majorpost, category: event)
	    	end
	    	#Check level
	    	i = user.level
	    	while user.points >= LevelXp.find(i).total_xp_required
	    		real_level = i
	    		i += 1
	    	end
	    	if real_level > user.level
	    		#level up user
	    		user.update(
	    			user.level = real_level
	    		)
	    		Notification.create(
	    			user_id: user.id,
	    			trackable_id: user.level,
	    			trackable_type: "Level",
	    			Notification_type: "level_up"
	    		)
	    	end
	   	end
    end

end
