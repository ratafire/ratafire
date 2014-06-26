class HelpsController < ApplicationController

	layout 'application'

	def show
	end

	#Projects

	def how_do_I_start_a_project
		@flag = true
	end

	def what_are_major_posts
	end

	def how_do_I_add_inspirations
	end

	def how_do_I_embed_code
	end

	def how_do_I_insert_equations
	end

	def how_do_I_upload_or_embed_a_video
	end

	def how_do_I_upload_an_artwork
	end

	def what_is_early_access
	end

	#Subscriptions

	def how_do_I_setup_subscription
	end

	def how_do_I_subscribe_to_another_user
	end

	def how_do_I_check_transactions
		@flag = true
	end

	#Social

	def look_around
		@flag = true
	end

	def what_are_the_goals_on_my_profile_page
	end


end