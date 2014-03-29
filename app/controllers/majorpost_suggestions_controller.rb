class MajorpostSuggestionsController < ApplicationController
	def index
		render json: MajorpostSuggestion.terms_for(params[:term])
	end
end
