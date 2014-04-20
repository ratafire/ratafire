class PpInspirationsController < ApplicationController
	def destroy
		@p_p_inspiration = P_P_Inspiration.find(params[:id])
		projectname = @p_p_inspiration.inspirer.title
		@p_p_inspiration.destroy
		flash[:success] = "Project '#{projectname}' deleted from inspired by."
		redirect_to(:back)
	end
end