class PuInspirationsController < ApplicationController
	def destroy
		@p_u_inspiration = P_U_Inspiration.find(params[:id])
		username = @p_u_inspiration.inspirer.fullname
		@p_u_inspiration.destroy
		flash[:success] = "#{username} deleted from inspired by."
		redirect_to(:back)
	end
end