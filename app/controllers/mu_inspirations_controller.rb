class MuInspirationsController < ApplicationController
	def destroy
		@m_u_inspiration = M_U_Inspiration.find(params[:id])
		username = @m_u_inspiration.inspirer.fullname
		@m_u_inspiration.destroy
		flash[:success] = "#{username} deleted from inspired by."
		redirect_to(:back)
	end
end