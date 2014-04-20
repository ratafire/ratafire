class ProjectSuggestionsController < ApplicationController
	def index
		render json: ProjectSuggestion.terms_for(params[:term])
	end
end
