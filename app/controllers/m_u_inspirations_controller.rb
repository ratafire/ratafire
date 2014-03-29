class M_U_InspirationsController < ApplicationController
	def create
		@m_u_inspiration = M_U_Inspiration.new(params[:m_u_inspirations])
	end
end