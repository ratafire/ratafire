class Global::SoftwareLanguageController < ApplicationController

	protect_from_forgery :except => [:create]

	#Before filters

	#REST Methods -----------------------------------

	#NoREST Methods -----------------------------------

	#global_switch
	#/global/software_language/:locale/switch
	def switch
		if current_user
			unless current_user.locale == params[:locale]
				current_user.locale = params[:locale]
				current_user.save
			end
		end
		cookies['locale'] = params[:locale]
		I18n.locale = params[:locale]
		redirect_to :back
	end

private

end