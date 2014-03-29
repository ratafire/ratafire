class PeInspirationsController < ApplicationController
	def destroy
		@p_e_inspiration = P_E_Inspiration.find(params[:id])
		title = @p_e_inspiration.title
		@p_e_inspiration.destroy
		flash[:success] = "External link '#{title}' deleted from inspired by."
		redirect_to(:back)
	end
end