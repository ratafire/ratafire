class BifrostsController < ApplicationController

	rescue_from "Mechanize::ResponseCodeError", with: :external_link_404

	def create
		@bifrost = Bifrost.create(params[:bifrost])
		@connection_count = 0
		@connection_input_count = @bifrost.connections.count
		#bifrost for projects
		if @bifrost.project_id != nil
			@project = Project.find(@bifrost.project_id)
			link_robot_project
		else
			@majorpost = Majorpost.find(@bifrost.majorpost_id)
			@project = @majorpost.project
			link_robot_majorpost
		end
		redirect_to(:back)
		#tell the user whether all of them are connected
		if @connection_count == 0 then
			flash[:success] = "No inspiration connected."
		else
			if @connection_count == @connection_input_count
				flash[:success] = "#{@connection_count} connected!"
			else
				#lost_connection = @connection_input_count - @connection_count
				flash[:success] = "The Bifrost shaked a bit, but it still worked."
			end
		end
		#Close the bifrost entirely after everything is done
		@bifrost.destroy
	end

private

	#anlyze links
	def link_robot_project
		@bifrost.connections.each do |c|
			#See if it is a link
			if c.url =~ URI::regexp(%w(http https)) then
				#See if it is an internal link
				if c.url =~ /(http|https):\/\/(www.|)ratafire.com/ then
					splitted = c.url.split("/")
					@user_name = splitted[3]
					@project_slug = splitted[4]
					@majorpost_slug = splitted[5]

					#get inspirers
					@user_inspirer = User.find_by_username(@user_name)
					@project_inspirer = Project.find_by_perlink(@project_slug)
					@majorpost_inspirer = Majorpost.find_by_slug(@majorpost_slug)

					#When the inspiration is a user
					p_u_inspiration_robot

					#When the inspiration is a project
					p_p_inspiration_robot

					#When the inspiration is a majorpost
					p_m_inspiration_robot

				else
					@external_url = c.url
					#When the inspiration is an external source
					p_e_inspiration_robot
				end
				#close Bifrost after Loki has crossed
				c.destroy
			end # end of see if it is a link	
		end # end of bifrost.connections.each do

		#clean up messes
		#cannot refer to one project, then refer to its majorposts
		no_self_reference_project_majorpost_duplicated
		#cannot refer to already inspiring projects
		inspiring_project_project
		#cannot refer to already inspiring projects' majorposts
		inspiring_project_majorpost
		#cannot refer to already inspiring projects' users
		inspiring_project_user
		#cannot refer to already inspiring majorposts
		#cannot refer to already inspiring majorposts'user

	end # end of link_robot_project

	def link_robot_majorpost
		@bifrost.connections.each do |c|
			#See if it is a link
			if c.url =~ URI::regexp(%w(http https)) then
				#See if it is an internal link
				if c.url =~ /(http|https):\/\/(www.|)ratafire.com/ then
					splitted = c.url.split("/")
					@user_name = splitted[3]
					@project_slug = splitted[4]
					@majorpost_slug = splitted[5]

					#get inspirers
					@user_inspirer = User.find_by_username(@user_name)
					@project_inspirer = Project.find_by_perlink(@project_slug)
					@majorpost_inspirer = Majorpost.find_by_slug(@majorpost_slug)

					#when the inspiration is a user
					m_u_inspiration_robot

					#When the inspiration is a project
					m_p_inspiration_robot

					#When the inspiration is a majorpost
					m_m_inspiration_robot
				else
					@external_url = c.url
					#When the inspiration is an external source
					m_e_inspiration_robot
				end # end of see if it is an internal link
				#close Bifrost after Loki my king has passed!
				c.destroy
			end # end of see if it is a link
		end # end of bifrost.connections.each do

		#clean up messes
		#cannot refer to one project, then refer to its majorposts
		no_self_reference_majorpost_to_project_duplicated
	end

#Robots of Inspirations~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	def p_u_inspiration_robot
		#When the inspiration is a user
		if @user_name != nil && @project_slug == nil && @majorpost_slug == nil then
			if @user_inspirer != nil then #if this user exist~
				#This user cannot be one of the project user
				project_users ||= Array.new
				@project.users.each do |u| #this user cannot be one of the project user
					project_users.push(u)
				end
				unless project_users.include? @user_inspirer then
					#rule out existed user connections
					if @project.p_u_inspirations.count != 0 then
						#Get a list of existed p_u_inspirers
						existed_p_u_inspirers ||= Array.new
						@project.p_u_inspirations.each do |pu|
							existed_p_u_inspirers.push(pu.inspirer)
						end
						unless existed_p_u_inspirers.include? @user_inspirer then
							#~~~~~project-user bifrost~~~~~~
							p_u_inspiration_bifrost 
							#~~cannot refer to already inspiring projects' users
							inspiring_project_user
							#~~cannot refer to already inspiring majorposts'user
							inspiring_project_majorpost_user
						end
					else	
						#~~~~~project-user bifrost~~~~~~
						p_u_inspiration_bifrost 
						#~~cannot refer to already inspiring projects' users
						inspiring_project_user
						#~~cannot refer to already inspiring majorposts'user
						inspiring_project_majorpost_user
					end
				end					
			end
		end
	end

	def p_p_inspiration_robot
		#When the inspiration is a project
		if @user_name != nil && @project_slug != nil && @majorpost_slug == nil then
			if @project_inspirer != nil && @project.perlink != @project_inspirer then #cannot refer to the same project
				#rule out existed project connections
				if @project.p_p_inspirations.count != 0 then
					#Get a list of existed p_p_inspirers
					existed_p_p_inspirers ||= Array.new
					@project.p_p_inspirations.each do |pp|
						existed_p_p_inspirers.push(pp.inspirer)
					end
					unless existed_p_p_inspirers.include? @project_inspirer then
						#~~~~~~project-project bifrost~~~~~~
						p_p_inspiration_bifrost 
						#~~cannot refer to projects by the same creator~~
						no_self_reference_project_same_creator
						#~~cannot refer to already inspiring project
						inspiring_project_project
						#~~cannot refer to already inspiring majorposts' project
						inspiring_project_majorpost_project
					end
				else
					#~~~~~~project-project bifrost~~~~~~
					p_p_inspiration_bifrost 
					#~~cannot refer to projects by the same creator~~
					no_self_reference_project_same_creator
					#~~cannot refer to already inspiring project
					inspiring_project_project
					#~~cannot refer to already inspiring majorposts' project
					inspiring_project_majorpost_project
				end
			end
		end		
	end

	def p_m_inspiration_robot
		#When the inspiration is a majorpost
		if @user_name != nil && @project_slug != nil && @majorpost_slug != nil then
			if @majorpost_inspirer != nil then
				#rule out existed majorpost connections
				if @project.p_m_inspirations.count != 0 then
					#Get a list of existed p_m_inspirers
					existed_p_m_inspirers ||= Array.new
					@project.p_m_inspirations.each do |pm|
						existed_p_m_inspirers.push(pm.inspirer)
					end
					unless existed_p_m_inspirers.include? @majorpost_inspirer then
						#~~~~~~project-majorpost bifrost~~~~~~
						p_m_inspiration_bifrost
						#~~cannot refer to majorposts of this project~~
						no_self_reference_project_same_majorposts
						#~~cannot refer to majorposts of the same user~~
						no_self_reference_project_majorpost_same_user
						#~~cannot refer to already inspiring projects' majorposts
						inspiring_project_majorpost
						#~~cannot refer to already inspiring majorposts
						inspiring_project_majorpost
					end
				else
					#~~~~~~project-majorpost bifrost~~~~~~
					p_m_inspiration_bifrost 
					#~~cannot refer to majorposts of this project~~
					no_self_reference_project_same_majorposts
					#~~cannot refer to majorposts of the same user~~
					no_self_reference_project_majorpost_same_user
					#~~cannot refer to already inspiring projects' majorposts
					inspiring_project_majorpost
					#~~cannot refer to already inspiring majorposts
					inspiring_project_majorpost
				end
			end
		end	
	end

	def p_e_inspiration_robot
		#When the inspiration is an external source
		#c.internal = false
		#rule out existed external connections
		if @project.p_e_inspirations.count != 0 then
			#Get a List of existed connections
			existed_urls ||= Array.new
			@project.p_e_inspirations.each do |u|
				existed_urls.push(u.url)
			end
			unless existed_urls.include? @external_url then
				p_e_inspiration_bifrost
			end	
		else
			#~~~~~~project-external bifrost~~~~~~
			p_e_inspiration_bifrost
		end		
	end

	def m_u_inspiration_robot
		#When the inspiration is a user
		if @user_name != nil && @project_slug == nil && @majorpost_slug == nil then
			if @user_inspirer != nil then #if this user exist~
				#This user cannot be one of the project user
				project_users ||= Array.new
				@project.users.each do |u|
					project_users.push(u)
				end	
				unless project_users.include? @user_inspirer then
					#rule out existed user connections
					if @majorpost.m_u_inspirations.count != 0 then
						#Get a link of existed m_u_inspirers
						existed_m_u_inspirers ||= Array.new
						@majorpost.m_u_inspirations.each do |mu|
							existed_m_u_inspirers.push(mu.inspirer)
						end
						unless existed_m_u_inspirers.include? @user_inspirer then
							#~~~~majorpost-user bifrost~~~~~
							m_u_inspiration_bifrost
							#~~cannot refer to already inspiring projects' users
							inspiring_majorpost_user
							#~~cannot refer to already inspiring majorposts'user
							inspiring_majorpost_majorpost_user
						end
					else
						#~~~~majorpost-user bifrost~~~~~
						m_u_inspiration_bifrost
						#~~cannot refer to already inspiring projects' users
						inspiring_majorpost_user
						#~~cannot refer to already inspiring majorposts'user
						inspiring_majorpost_majorpost_user
					end		
				end
			end
		end
	end

	def m_p_inspiration_robot
		#When the inspiration if a project
		if @user_name != nil && @project_slug != nil && @majorpost_slug == nil then
			if @project_inspirer != nil && @project.perlink != @project_inspirer then #cannot refer to the same project
				#rule out existed project connections
				if @majorpost.m_p_inspirations.count != 0 then
					#Get a list of existed m_p_connections
					existed_m_p_inspirers ||= Array.new
					@majorpost.m_p_inspirations.each do |mp|
						existed_m_p_inspirers.push(mp.inspirer)
					end
					unless existed_m_p_inspirers.include? @project_inspirer then
						#~~~~~~~majorpost-project bifrost~~~~~~~
						m_p_inspiration_bifrost
						#~~cannot refer to projects by the same user
						no_self_reference_majorpost_project_same_user
						#~~cannot refer to already inspiring projects
						inspiring_majorpost_project
						#~~cannot refer to already inspiring majorposts' project
						inspiring_majorpost_majorpost_project
					end
				else
					#~~~~~~~majorpost-project bifrost~~~~~~~
					m_p_inspiration_bifrost
					#~~cannot refer to projects by the same user
					no_self_reference_majorpost_project_same_user
					#~~cannot refer to already inspiring projects
					inspiring_majorpost_project
					#~~cannot refer to already inspiring majorposts' project
					inspiring_majorpost_majorpost_project
				end	
			end
		end
	end

	def m_m_inspiration_robot
		#When the inspiration is a majorpost
		if @user_name != nil && @project_slug != nil && @majorpost_slug != nil then
			if @majorpost_inspirer != nil then
				#rule out existed majorpost connections
				if @majorpost.m_m_inspirations.count != 0 then
					#Get a list of existed m_m_inspirers
					existed_m_m_inspirers ||= Array.new
					@majorpost.m_m_inspirations.each do |mm|
						existed_m_m_inspirers.push(mm.inspirer)
					end
					unless existed_m_m_inspirers.include? @majorpost_inspirer then
						#~~~~~~majorpost-majorpost bifrost~~~~~~
						m_m_inspiration_bifrost
						#~~cannot refer to majorposts of this project~~~
						no_self_reference_majorpost_project_same_majorposts
						#~~cannot refer to majorposts of the same user~~~
						no_self_reference_majorpost_same_user
						#~~cannot refer to already inspiring projects' majorposts
						inspiring_majorpost_majorpost
						#~~cannot refer to already inspiring majorposts
						inspiring_majorpost_majorpost
					end
				else
					#~~~~~~majorpost-majorpost bifrost~~~~~~
					m_m_inspiration_bifrost
					#~~cannot refer to majorposts of this project~~~
					no_self_reference_majorpost_project_same_majorposts
					#~~cannot refer to majorposts of the same user~~~
					no_self_reference_majorpost_same_user
					#~~cannot refer to already inspiring projects' majorposts
					inspiring_majorpost_majorpost
					#~~cannot refer to already inspiring majorposts
					inspiring_majorpost_majorpost
				end
			end
		end
	end

	def m_e_inspiration_robot
		#When the inspiration is an exteranl source
		#rule out existed external connections
		if @majorpost.m_e_inspirations.count != 0 then
			#Get a List of existed connections
			existed_urls ||= Array.new
			@majorpost.m_e_inspirations.each do |u|
				existed_urls.push(u.url)
			end
			unless existed_urls.include? @external_url then
				#~~~~~~majorpost-external bifrost~~~~~~
				m_e_inspiration_bifrost
			end
		else
			#~~~~~~majorpost-external bifrost~~~~~~
			m_e_inspiration_bifrost
		end
	end

#list of bifrosts~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	def p_u_inspiration_bifrost
		#finnally Heimdall can open the project-user bifrost
		@p_u_inspiration = P_U_Inspiration.new 
		@p_u_inspiration.inspirer_id = @user_inspirer.id
		@p_u_inspiration.inspired_id = @project.id
		@p_u_inspiration.save
		@connection_count += 1
	end

	def p_p_inspiration_bifrost
		#finnally Heimdall can open the project-project bifrost
		@p_p_inspiration = P_P_Inspiration.new 
		@p_p_inspiration.inspirer_id = @project_inspirer.id
		@p_p_inspiration.inspired_id = @project.id
		@p_p_inspiration.save
		@connection_count += 1
	end

	def p_m_inspiration_bifrost
		#finnally Heimdall can open the project-majorpost bifrost
		@p_m_inspiration = P_M_Inspiration.new 
		@p_m_inspiration.inspirer_id = @majorpost_inspirer.id
		#set the inspirer to not deletable
		if @majorpost_inspirer.edit_permission == "free" then
			@majorpost_inspirer.edit_permission = "edit"
			@majorpost_inspirer.save
		end
		@p_m_inspiration.inspired_id = @project.id
		@p_m_inspiration.save
		@connection_count += 1
	end

	def p_e_inspiration_bifrost
		#finnally Heimdall can open the project-external bifrost
		@p_e_inspiration = P_E_Inspiration.new
		@p_e_inspiration.url = @external_url
		@p_e_inspiration.title = Mechanize.new.get(@external_url).title
		@p_e_inspiration.inspired_id = @project.id
		@p_e_inspiration.save
		@connection_count += 1
	end

	def m_u_inspiration_bifrost
		#Heimdall!!!
		@m_u_inspiration = M_U_Inspiration.new
		@m_u_inspiration.inspirer_id = @user_inspirer.id
		@m_u_inspiration.inspired_id = @majorpost.id
		@m_u_inspiration.save
		@connection_count += 1
	end	

	def m_p_inspiration_bifrost
		#Heimdall sees everything
		@m_p_inspiration = M_P_Inspiration.new
		@m_p_inspiration.inspirer_id = @project_inspirer.id
		@m_p_inspiration.inspired_id = @majorpost.id
		@m_p_inspiration.save
		@connection_count += 1
	end

	def m_m_inspiration_bifrost
		#Heimdall cannot see Loki
		@m_m_inspiration = M_M_Inspiration.new
		@m_m_inspiration.inspirer_id = @majorpost_inspirer.id
		#Set the inspirer to undeletable
		if @majorpost_inspirer.edit_permission == "free" then
			@majorpost_inspirer.edit_permission = "edit"
			@majorpost_inspirer.save
		end
		@m_m_inspiration.inspired_id = @majorpost.id
		@m_m_inspiration.save
		@connection_count += 1
	end

	def m_e_inspiration_bifrost
		#Heimdal needs some rest
		@m_e_inspiration = M_E_Inspiration.new
		@m_e_inspiration.url = @external_url
		@m_e_inspiration.title = Mechanize.new.get(@external_url).title
		@m_e_inspiration.inspired_id = @majorpost.id
		@m_e_inspiration.save
		@connection_count += 1
	end

#list of no-selfreferences~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	def no_self_reference_project_same_creator
		#cannot refer to projects by the same creator
		@project.creator.projects.each do |p|
			if p.id == @p_p_inspiration.inspirer_id then
				@p_p_inspiration.destroy
				@connection_count -= 1
			end
		end	
	end

	def no_self_reference_project_same_majorposts
		#cannot refer to majorposts of this project
		@project.majorposts.each do |m|
			if m.id == @p_m_inspiration.inspirer_id then
				@p_m_inspiration.destroy
				@connection_count -= 1
			end
		end
	end

	def no_self_reference_project_majorpost_same_user
		#cannot refer to majorposts of the same user
		if @p_m_inspiration.inspirer_id == @project.creator.id then
			@p_m_inspiration.destroy 
			@connection_count -= 1
		end
	end

	def no_self_reference_project_majorpost_duplicated
		#cannot refer to one project, then refer to its majorposts
		if @project.p_m_inspirations.count != 0 && @project.p_p_inspirations.count != 0 then
			@project.p_m_inspirations.each do |pm|
				@project.p_p_inspirations.each do |pp|
					if pm.inspirer.project == pp.inspirer then
						pm.destroy
					end
				end
			end
		end
	end

	def no_self_reference_majorpost_project_same_user
		#cannot refer to projects by the same user
		@majorpost.user.projects.each do |p|
			if p.id == @m_p_inspiration.inspirer_id then
				@m_p_inspiration.destroy
				@connection_count -= 1
			end
		end
	end

	def no_self_reference_majorpost_project_same_majorposts
		#cannot refer to majorposts of this project~~~
		@project.majorposts.each do |m|
			if m.id == @m_m_inspiration.inspirer_id then
				@m_m_inspiration.destroy
				@connection_count -= 1
			end
		end
	end

	def no_self_reference_majorpost_same_user
		#cannot refer to majorposts of the same user~~~
		if @m_m_inspiration.inspirer_id == @majorpost.user.id then
			@m_m_inspiration.destroy
			@connection_count -= 1
		end
	end
					
	def	no_self_reference_majorpost_to_project_duplicated
		#cannot refer to one project, then refer to its majorposts
		if @majorpost.m_p_inspirations.count != 0 && @majorpost.m_m_inspirations.count != 0 then
			@majorpost.m_p_inspirations.each do |mp|
				@majorpost.m_m_inspirations.each do |mm|
					if mm.inspirer.project == mp.inspirer then
						mm.destroy
					end
				end
			end
		end	
	end

#List of Inspiring after filters~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def inspiring_project_project
	#~~cannot refer to already inspiring project
	if @project.inspired_projects.count != 0 then
		existed_inspired_projects ||= Array.new
		@project.inspired_projects.each do |rpp|
			existed_inspired_projects.push(rpp.id)
		end
		if @p_p_inspiration != nil then
			if existed_inspired_projects.include? @p_p_inspiration.inspirer.id then
				@p_p_inspiration.destroy
				@connection_count -= 1
			end
		end
	end
end

def inspiring_project_majorpost
	#~~cannot refer to already inspiring projects' majorposts
	if @project.inspired_projects.count != 0 then
		existed_inspired_projects_majorposts ||= Array.new
		@project.inspired_projects.each do |rpp|
			rpp.majorposts.each do |rppm|
				existed_inspired_projects_majorposts.push(rppm.id)
			end
		end
		if existed_inspired_projects_majorposts.include? @p_m_inspiration.inspirer.id then
			@p_m_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_project_user
	#~~cannot refer to already inspiring projects' users
	if @project.inspired_projects.count != 0 then
		existed_inspired_projects_users ||= Array.new
		@project.inspired_projects.each do |rpp|
			rpp.users.each do |rppu|
				existed_inspired_projects_users.push(rppu.id)
			end
		end	
		if existed_inspired_projects_users.include? @p_u_inspiration.inspirer.id then
			@p_u_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_project_majorpost_project
	#~~cannot refer to already inspiring majorposts' project
	if @project.inspired_majorposts.count != 0 then
		existed_inspired_majorposts_projects ||= Array.new
		@project.inspired_majorposts.each do |rpm|
			existed_inspired_majorposts_projects.push(rpm.project.id)
		end
		if existed_inspired_majorposts_projects.include? @p_p_inspiration.inspirer.id  then
			@p_p_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_project_majorpost
	#~~cannot refer to already inspiring majorposts
	if @project.inspired_majorposts.count != 0 then
		exited_inspired_majorposts ||= Array.new
		@project.inspired_majorposts.each do |rpm|
			exited_inspired_majorposts.push(rpm.id)
		end
		if exited_inspired_majorposts.include? @p_m_inspiration.inspirer.id then
			@p_m_inspiration.destroy
			@connection_count -= 1
		end
	end
end


def inspiring_project_majorpost_user
	#~~cannot refer to already inspiring majorposts'user
	if @project.inspired_majorposts.count != 0 then
		exited_inspired_majorposts_users ||= Array.new
		@project.inspired_majorposts.each do |rpm|
			exited_inspired_majorposts_users.push(rpm.user.id)
		end
		if exited_inspired_majorposts_users.include? @p_u_inspiration.inspirer.id then
			@p_u_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_majorpost_project
	#cannot refer to already inspiring projects
	if @majorpost.inspired_projects.count != 0 then
		existed_inspired_projects ||= Array.new
		@majorpost.inspired_projects.each do |rmp|
			existed_inspired_projects.push(rmp.id)
		end
		if existed_inspired_projects.include? @m_p_inspiration.inspirer.id then
			@m_p_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_majorpost_majorpost
	#cannot refer to already inspiring projects' majorposts
	if @majorpost.inspired_projects.count != 0 then
		existed_inspired_projects_majorposts ||= Array.new
		@majorpost.inspired_projects.each do |rmp|
			rmp.majorposts.each do |rmpm|
				existed_inspired_projects_majorposts.push(rmpm.id)
			end
		end
		if existed_inspired_projects_majorposts.include? @m_m_inspiration.inspirer.id then
			@m_m_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_majorpost_user
	#cannot refer to already inspiring projects' users
	if @majorpost.inspired_projects.count != 0 then
		existed_inspired_projects_users ||= Array.new
		@majorpost.inspired_projects.each do |rmp|
			rmp.project.users.each do |rmpu|
				existed_inspired_projects_users.push(rmpu.id)
			end
		end
		if existed_inspired_projects_users.include? @m_u_inspiration.inspirer.id then
			@m_u_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_majorpost_majorpost_project
	#cannot refer to already inspiring majorposts' project
	if @majorpost.inspired_majorposts.count != 0 then
		existed_inspired_majorposts_projects ||= Array.new
		@majorpost.inspired_majorposts.each do |rmm|
			existed_inspired_majorposts_projects.push(rmm.project.id)
		end
		if existed_inspired_majorposts_projects.include? @m_p_inspiration.inspirer.id then
			@m_p_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_majorpost_majorpost
	#cannot refer to already inspiring majorposts
	if @majorpost.inspired_majorposts.count != 0 then
		existed_inspired_majorposts ||= Array.new
		@majorpost.inspired_majorposts.each do |rmm|
			existed_inspired_majorposts.push(rmm.id)
		end
		if existed_inspired_majorposts.include? @m_m_inspiration.inspirer.id then
			@m_m_inspiration.destroy
			@connection_count -= 1
		end
	end
end

def inspiring_majorpost_majorpost_user
	#cannot refer to already inspiring majorposts'user
	if @majorpost.inspired_majorposts.count != 0 then
		existed_inspired_majorposts_users ||= Array.new
		@majorpost.inspired_majorposts.each do |rmm|
			existed_inspired_majorposts_users.push(rmm.user.id)
		end
		if existed_inspired_majorposts_users.include? @m_u_inspiration.inspirer.id then
			@m_u_inspiration.destroy
			@connection_count -= 1
		end
	end
end	

#list of 404 Rescues~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	def external_link_404
		url = @bifrost.connections.first.url[ 0 .. 40 ] + "..."
		flash[:success] = "'#{url}' caused connection error, remove it and try again."
		redirect_to(:back)
	end

end