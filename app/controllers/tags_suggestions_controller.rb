class TagsSuggestionsController < ApplicationController
	def index
		render json: TagsSuggestion.terms_for(params[:term])
	end
end
