module ProjectsHelper

	#find the AssignedProject
	def assignedproject(user_id, project_id)
		assignedproject = AssignedProject.find_by_user_id_and_project_id(user_id, project_id)
		return assignedproject 
	end

	#find the p_u_inspiration id
	def find_p_u_inspiration_id(user)
		return @project.p_u_inspirations.find_by_inspirer_id(user.id).id		 
	end

	#find the p_p_inspiration id
	def find_p_p_inspiration_id(project)
		return @project.p_p_inspirations.find_by_inspirer_id(project.id).id 
	end

	#find the p_m_inspiration id
	def find_p_m_inspiration_id(majorpost)
		return @project.p_m_inspirations.find_by_inspirer_id(majorpost.id).id
	end

	#find the p_e_inspiration id
	def find_p_e_inspiration_id(external)
		return @project.p_e_inspirations.find_by_url(external.url).id
	end

	#find the m_u_inspiration id
	def find_m_u_inspiration_id(user)
		return @majorpost.m_u_inspirations.find_by_inspirer_id(user.id).id
	end

	#find the m_p_inspiration id
	def find_m_p_inspiration_id(project)
		return @majorpost.m_p_inspirations.find_by_inspirer_id(project.id).id 
	end

	#find the m_m_inspiration id
	def find_m_m_inspiration_id(majorpost)
		return @majorpost.m_m_inspirations.find_by_inspirer_id(majorpost.id).id
	end

	#find the m_e_inspiration id
	def find_m_e_inspiration_id(external)
		return @majorpost.m_e_inspirations.find_by_url(external.url).id
	end 

	#See if the user is invited
	def invited?(user)
		invited_users ||= Array.new(5)
		@project.inviteds.each do |i|
			invited_users.push(i.user_id)
		end
		if invited_users.include? user.id then
			return true
		else
			return false
		end	
	end

	#Inspiration Showing Rules
	def project_inspiration_normal
		if @project.user_inspirers.any? || @project.project_inspirers.any? || @project.majorpost_inspirers.any? || @project.p_e_inspirations.any? then
			return true
		else
			return false
		end	
	end

	def project_inspiration_edit
		if @project.user_inspirers.any? || @project.project_inspirers.any? || @project.majorpost_inspirers.any? || @project.p_e_inspirations.any? then
			return true
		else
			if project_edit(@project) then
				return true
			else
				return false
			end
		end	
	end

	def project_contributors_delete(user)
		existed_majorpost_user_list ||= Array.new
		@project.majorposts.each do |m|
			existed_majorpost_user_list.push(m.user.id)
		end
		unless existed_majorpost_user_list.include? user.id then
			if project_edit(@project) && user.id != @project.creator_id then
				if @project.complete == true then
					if assignedproject(user.id, @project.id).created_at > @project.completion_time then
						return true
					else
						return false
					end
				else
					return true
				end
			else
				return false
			end
		else
			return false
		end
	end	

	def project_contributors_leave(user)
		existed_majorpost_user_list ||= Array.new
		@project.majorposts.each do |m|
			existed_majorpost_user_list.push(m.user.id)
		end
		unless existed_majorpost_user_list.include? user.id then
			if current_user == user && current_user != @project.creator then
				if @project.complete == true then
					if assignedproject(user.id, @project.id).created_at > @project.completion_time then
						return true
					else
						return false
					end
				else
					return true
				end
			else
				return false
			end
		else
			return false
		end	
	end	

	#Check if to show to subscribers
	def show_to_subscribers?(project)
		user = project.creator
		if user.subscription_switch == true && user.amazon_authorized == true && user.why != nil && user.why != "" && user.plan != nil && user.plan != "" && user.subscription_amount < user.goals_monthly && project != nil then
			#Add user's single project
			return true
		else
			return false
		end
	end

end