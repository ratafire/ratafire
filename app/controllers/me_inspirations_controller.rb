class MeInspirationsController < ApplicationController
	def destroy
		@m_e_inspiration = M_E_Inspiration.find(params[:id])
		title = @m_e_inspiration.title
		@m_e_inspiration.destroy
		flash[:success] = "External link '#{title}' deleted from inspired by."
		redirect_to(:back)
	end
end