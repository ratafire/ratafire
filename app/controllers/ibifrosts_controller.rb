class IbifrostsController < ApplicationController

	def create
		@ibifrost = Ibifrost.create(params[:ibifrost])
		@project = Project.find(@ibifrost.project_id)
		@invitation_count = 0
		@invitation_input_count = @ibifrost.inviteds.count
		#invitation robot
		if @project.inviteds.count <= 5 then
			invitation_robot
			redirect_to(:back)
			if @invitation_count == 0 then
				flash[:success] = "No user invited."
			else 
				if @invitation_count == @invitation_input_count then
					flash[:success] = "#{@invitation_count} invited!"
				else
					flash[:success] = "Some are invited, others are not."
				end
			end
		else
			redirect_to(:back)
			flash[:success] = "Focus, there can only be 5 pending invitations."
		end
		#close the ibifrost completely
		@ibifrost.destroy
	end

private

	def invitation_robot
		@ibifrost.inviteds.each do |i|
			user = User.find_by_username(i.username)
			#rule out existed inviteds
			if @project.inviteds.count != 0 then
				if @project.inviteds.include? user then
					i.destroy
				else
					if @project.users.include? user then
						i.destroy
					else
						if user != nil then
							i.user_id = user.id
							i.project_id = @project.id
							i.save
							@invitation_count += 1
						else
							i.destroy
						end
					end 
				end
			else
				if @project.users.include? user then
					i.destroy
				else
					if user != nil then
						i.user_id = user.id
						i.project_id = @project.id
						i.save
						@invitation_count += 1
					else
						i.destroy
					end
				end 
			end
		end
	end

end