class Explore::CategoriesController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_category, only:[:categories]

	#REST Methods -----------------------------------
	#NoREST Methods -----------------------------------

	# explore_categories GET
	# /explore/categories
	def index
		
	end


private

end