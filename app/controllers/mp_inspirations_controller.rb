class MpInspirationsController < ApplicationController
	def destroy
		@m_p_inspiration = M_P_Inspiration.find(params[:id])
		projectname = @m_p_inspiration.inspirer.title
		@m_p_inspiration.destroy
		flash[:success] = "Project '#{projectname}' deleted from inspired by."
		redirect_to(:back)
	end
end