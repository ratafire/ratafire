class PmInspirationsController < ApplicationController
	def destroy
		@p_m_inspiration = P_M_Inspiration.find(params[:id])
		majorpostname = @p_m_inspiration.inspirer.title
		@p_m_inspiration.destroy
		flash[:success] = "Major post '#{majorpostname}' deleted from inspired by."
		redirect_to(:back)
	end
end