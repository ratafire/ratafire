class Explore::CategoriesController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user
	before_filter :show_followed
	#REST Methods -----------------------------------
	#NoREST Methods -----------------------------------

	# explore_categories GET
	# /explore/categories
	def index
	end

	#Art

	# explore_category_art GET
	# /explore/categories/:category_id/art
	def art
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "a new field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_concept_art
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "concept art", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_3d_model
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "3D model", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_drawing
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "drawing", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_painting
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "painting", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_architecture
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "architecture", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_interior_design
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "interior design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_photography
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "photography", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_graphic_design
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "graphic design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_sculpting
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "sculpting", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_jewelry_design
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "jewelry design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "art", sub_category: "other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Music

	def music
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", sub_category: "a new field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_composition
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", sub_category: "composition", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_soundtrack
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", sub_category: "soundtrack", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_rock
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", sub_category: "rock", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_pop
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", sub_category: "pop", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_cover
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", sub_category: "cover", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_classical
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", sub_category: "classical", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "music", sub_category: "other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Games

	def games
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "a new field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_rpg
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "composition", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_strategy
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "strategy", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_simulation
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "simulation", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_mmo
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "mmo", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_action
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "action", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_sport
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "sport", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_adventure
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "adventure", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "games", sub_category: "other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Writing

	def writing
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", sub_category: "a new field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_science_fiction
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", sub_category: "science fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_fantasy
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", sub_category: "fantasy", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_review
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", sub_category: "review", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_poetry
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", sub_category: "poetry", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_non_fiction
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", sub_category: "non fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_fiction
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", sub_category: "fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "writing", sub_category: "other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Videos

	def videos
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", sub_category: "a new field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_gaming
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", sub_category: "gaming", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_cg
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", sub_category: "cg", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_animation
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", sub_category: "animation", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end	

	def videos_movies
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", sub_category: "movies", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_documentary
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", sub_category: "documentary", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_tutorial
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", sub_category: "tutorial", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"],category: "videos", sub_category: "other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

private

	def load_user
		if user_signed_in?
			@user = current_user
		end
	end

	def show_followed
		if user_signed_in?
			@followed = current_user.likeds.order("last_seen desc").page(params[:followed_update]).per_page(3)
		end
	end

end