class Explore::CategoriesController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_user
	before_filter :show_followed
	before_filter :show_category, except: [:index, :category, :sub_category]
	#REST Methods -----------------------------------
	#NoREST Methods -----------------------------------

	# explore_categories GET
	# /explore/categories
	def index
	end

	# explore_category_category GET
	# /explore/categories/:category_id/explore/categories/:category_id
	def category
		case params[:category_id]
		when 'Art'
			redirect_to explore_category_art_path
		when 'Music'
			redirect_to explore_category_music_path
		when 'Games'
			redirect_to explore_category_games_path
		when 'Writing'
			redirect_to explore_category_writing_path
		when 'Videos'
			redirect_to explore_category_videos_path
		end
	end

	# explore_category_sub_category GET
	# /explore/categories/:category_id/explore/categories/:category_id/:sub_category_id
	def sub_category
		case params[:category_id]
		when 'Art'
			case params[:sub_category_id]
			when 'A New Field'
				redirect_to art_a_new_field_path
			when 'Concept Art'
				redirect_to art_concept_art_path
			when '3D Models'
				redirect_to art_3d_model_path
			when 'Drawing'
				redirect_to art_drawing_path
			when 'Painting'
				redirect_to art_painting_path
			when 'Architecture'
				redirect_to art_architecture_path
			when 'Interior Design'
				redirect_to art_interior_design_path
			when 'Photography'
				redirect_to art_photography_path
			when 'Graphic Design'
				redirect_to art_graphic_design_path
			when 'Sculpting'
				redirect_to art_sculpting_path
			when 'Jewelry Design'
				redirect_to art_jewelry_design_path
			when 'Other'
				redirect_to art_other_path
			end
		when 'Music'
			case params[:sub_category_id]
			when 'A New Field'
				redirect_to music_a_new_field_path
			when 'Composition'
				redirect_to music_composition_path
			when 'Soundtrack'
				redirect_to music_soundtrack_path
			when 'Rock'
				redirect_to music_rock_path
			when 'Pop'
				redirect_to music_pop_path
			when 'Cover'
				redirect_to music_cover_path
			when 'Classical'
				redirect_to music_classical_path
			when 'Other'
				redirect_to music_other_path
			end
		when 'Games'
			case params[:sub_category_id]
			when 'A New Field'
				redirect_to games_a_new_field_path
			when 'RPG'
				redirect_to games_rpg_path
			when 'Strategy'
				redirect_to games_strategy_path
			when 'Simulation'
				redirect_to games_simulation_path
			when 'MMO'
				redirect_to games_mmo_path
			when 'Action'
				redirect_to games_action_path
			when 'Sport'
				redirect_to games_sport_path
			when 'Adventure'
				redirect_to games_adventure_path
			when 'Other'
				redirect_to games_other_path
			end
		when 'Writing'
			case params[:sub_category_id]
			when 'A New Field'
				redirect_to writing_a_new_field_path
			when 'Review'
				redirect_to writing_review_path
			when 'Poetry'
				redirect_to writing_poetry_path
			when 'Fantasy'
				redirect_to writing_fantasy_path
			when 'Science Fiction'
				redirect_to writing_science_fiction_path
			when 'Non-fiction'
				redirect_to writing_non_fiction_path
			when 'Other'
				redirect_to writing_other_path
			end
		when 'Videos'
			case params[:sub_category_id]
			when 'A New Field'
				redirect_to videos_a_new_field_path
			when 'Gaming'
				redirect_to videos_gaming_path
			when 'Animation'
				redirect_to videos_animation_path
			when 'CG'
				redirect_to videos_cg_path
			when 'Movies'
				redirect_to videos_movies_path
			when 'Documentary'
				redirect_to videos_documentary_path
			when 'Tutorial'
				redirect_to videos_tutorial_path
			when 'Other'
				redirect_to videos_other_path
			end
		end
	end

	#Art

	# explore_category_art GET
	# /explore/categories/:category_id/art
	def art
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_concept_art
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Concept Art", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_3d_model
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "3D Models", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_drawing
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Drawing", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_painting
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Painting", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_architecture
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Architecture", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_interior_design
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Interior Design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_photography
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Photography", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_graphic_design
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Graphic Design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_sculpting
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Sculpting", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_jewelry_design
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Jewelry Design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Music

	def music
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_composition
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Composition", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_soundtrack
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Soundtrack", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_rock
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Rock", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_pop
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Pop", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_cover
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Cover", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_classical
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Classical", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Games

	def games
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_rpg
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Composition", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_strategy
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Strategy", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_simulation
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Simulation", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_mmo
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "MMO", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_action
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Action", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_sport
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Sport", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_adventure
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Adventure", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Writing

	def writing
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_science_fiction
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Science Fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_fantasy
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Fantasy", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_review
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Review", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_poetry
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Poetry", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_non_fiction
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Non-fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_fiction
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Videos

	def videos
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_a_new_field
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_gaming
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Gaming", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_cg
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "CG", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_animation
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Animation", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end	

	def videos_movies
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Movies", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_documentary
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Documentary", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_tutorial
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Tutorial", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_other
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
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

	def show_category
		@showcategory = true
	end

end