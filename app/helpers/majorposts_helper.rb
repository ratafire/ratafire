module MajorpostsHelper

	def get_next(majorpost)
		return majorpost.project.majorposts.where("id > ?", majorpost.id).where(:published => true).order("id ASC").last
	end

	def get_prev(majorpost)
		return majorpost.project.majorposts.where("id < ?", majorpost.id).where(:published => true).order("id DESC").first
	end

	#Inspiration Showing Rules
	def majorpost_inspiration_normal
		if @majorpost.user_inspirers.any? || @majorpost.project_inspirers.any? || @majorpost.majorpost_inspirers.any? || @majorpost.m_e_inspirations.any? then
			return true
		else
			return false
		end	
	end

	def majorpost_inspiration_edit
		if @majorpost.user_inspirers.any? || @majorpost.project_inspirers.any? || @majorpost.majorpost_inspirers.any? || @majorpost.m_e_inspirations.any? then
			return true
		else
			if majorpost_edit(@majorpost) then
				return true
			else
				return false
			end
		end	
	end

end