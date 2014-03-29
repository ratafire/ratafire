class MmInspirationsController < ApplicationController
	def destroy
		@m_m_inspiration = M_M_Inspiration.find(params[:id])
		majorpostname = @m_m_inspiration.inspirer.title
		@m_m_inspiration.destroy
		flash[:success] = "Major post '#{majorpostname}' deleted from inspired by."
		redirect_to(:back)
	end
end