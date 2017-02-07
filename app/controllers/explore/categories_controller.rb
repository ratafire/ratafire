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
			when 'Fashion'
				redirect_to art_fashion_path
			when 'Painting'
				redirect_to art_painting_path								
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
			when 'Fashion'
				redirect_to videos_fashion_path
			when 'Beauty'
				redirect_to videos_beauty_path
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
		meta_category(:category => I18n.t('views.utilities.menu.art'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_a_new_field
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.a_new_field'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_concept_art
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.concept_art'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Concept Art", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_3d_model
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.3D_model'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "3D Models", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_drawing
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.drawing'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Drawing", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_painting
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.painting'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Painting", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_fashion
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.fashion'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Fashion", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_beauty
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.beauty'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Beauty", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end		

	def art_architecture
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.architecture'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Architecture", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_interior_design
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.interior_design'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Interior Design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_photography
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.photography'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Photography", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_graphic_design
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.graphic_design'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Graphic Design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_sculpting
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.sculpting'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Sculpting", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_jewelry_design
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.art.jewelry_design'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Jewelry Design", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def art_other
		meta_category(:category => I18n.t('views.utilities.menu.art'), :sub_category => I18n.t('views.utilities.category.other'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Art", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Music

	def music
		meta_category(:category => I18n.t('views.utilities.menu.music'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_a_new_field
		meta_category(:category => I18n.t('views.utilities.menu.music'), :sub_category => I18n.t('views.utilities.category.a_new_field'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_composition
		meta_category(:category => I18n.t('views.utilities.menu.music'), :sub_category => I18n.t('views.utilities.category.music.composition'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Composition", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_soundtrack
		meta_category(:category => I18n.t('views.utilities.menu.music'), :sub_category => I18n.t('views.utilities.category.music.soundtrack'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Soundtrack", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_rock
		meta_category(:category => I18n.t('views.utilities.menu.music'), :sub_category => I18n.t('views.utilities.category.music.rock'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Rock", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_pop
		meta_category(:category => I18n.t('views.utilities.menu.music'), :sub_category => I18n.t('views.utilities.category.music.pop'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Pop", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_cover
		meta_category(:category => I18n.t('views.utilities.menu.music'), :sub_category => I18n.t('views.utilities.category.music.cover'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Cover", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_classical
		meta_category(:category => I18n.t('views.utilities.menu.music'), :sub_category => I18n.t('views.utilities.category.music.classical'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Classical", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def music_other
		meta_category(:category => I18n.t('views.utilities.menu.music'), :sub_category => I18n.t('views.utilities.category.other'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Music", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Games

	def games
		meta_category(:category => I18n.t('views.utilities.menu.games'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_a_new_field
		meta_category(:category => I18n.t('views.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.a_new_field'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_rpg
		meta_category(:category => I18n.t('views.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.games.rpg'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Composition", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_strategy
		meta_category(:category => I18n.t(v'iews.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.games.strategy'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Strategy", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_simulation
		meta_category(:category => I18n.t('views.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.games.simulation'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Simulation", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_mmo
		meta_category(:category => I18n.t('views.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.games.mmo'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "MMO", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_action
		meta_category(:category => I18n.t('views.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.games.action'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Action", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_sport
		meta_category(:category => I18n.t('views.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.games.sport'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Sport", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_adventure
		meta_category(:category => I18n.t('views.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.games.adventure'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Adventure", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def games_other
		meta_category(:category => I18n.t('views.utilities.menu.games'), :sub_category => I18n.t('views.utilities.category.other'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Games", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Writing

	def writing
		meta_category(:category => I18n.t('views.utilities.menu.writing'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_a_new_field
		meta_category(:category => I18n.t('views.utilities.menu.writing'), :sub_category => I18n.t('views.utilities.category.a_new_field'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_science_fiction
		meta_category(:category => I18n.t('views.utilities.menu.writing'), :sub_category => I18n.t('views.utilities.category.writing.science_fiction'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Science Fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_fantasy
		meta_category(:category => I18n.t('views.utilities.menu.writing'), :sub_category => I18n.t('views.utilities.category.writing.fantasy'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Fantasy", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_review
		meta_category(:category => I18n.t('views.utilities.menu.writing'), :sub_category => I18n.t('views.utilities.category.writing.review'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Review", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_poetry
		meta_category(:category => I18n.t('views.utilities.menu.writing'), :sub_category => I18n.t('views.utilities.category.writing.poetry'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Poetry", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_non_fiction
		meta_category(:category => I18n.t('views.utilities.menu.writing'), :sub_category => I18n.t('views.utilities.category.writing.non_fiction'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Non-fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_fiction
		meta_category(:category => I18n.t('views.utilities.menu.writing'), :sub_category => I18n.t('views.utilities.category.writing.fiction'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Fiction", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def writing_other
		meta_category(:category => I18n.t('views.utilities.menu.writing'), :sub_category => I18n.t('views.utilities.category.other'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Writing", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	#Videos

	def videos
		meta_category(:category => I18n.t('views.utilities.menu.videos'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_a_new_field
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.a_new_field'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "A New Field", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_gaming
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.videos.gaming'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Gaming", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_cg
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.videos.cg'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "CG", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_animation
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.videos.animation'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Animation", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end	

	def videos_fashion
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.videos.fashion'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Fashion", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end	

	def videos_beauty
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.videos.beauty'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Beauty", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end			

	def videos_movies
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.videos.movies'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Movies", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_documentary
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.videos.documentary'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Documentary", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_tutorial
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.videos.tutorial'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Tutorial", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

	def videos_other
		meta_category(:category => I18n.t('views.utilities.menu.videos'), :sub_category => I18n.t('views.utilities.category.other'))
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Campaign"], :published => true,category: "Videos", sub_category: "Other", :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 6)
	end

private

	def load_user
		if user_signed_in?
			@user = current_user
		end
	end

	def meta_category(options = {})
		unless options[:sub_category]
			#Without sub category
			#Normal meta tag
			set_meta_tags title: I18n.t('ratafire'),
						  description: I18n.t('tagline') + ' - ' + options[:category],
						  image_src: 'https://ratafire.com/assets/logo/screenshot.jpg'
			#Open Graph Object
			set_meta_tags og: {
				title:    I18n.t('ratafire') + ' - ' + options[:category],
				description: I18n.t('tagline'),
				type:     'website',
				image:    'https://ratafire.com/assets/logo/screenshot.jpg'
			}
			#Twitter Card
			set_meta_tags twitter: {
				card:  "summary_large_image",
				site: "ratafire.com",
				title: I18n.t('ratafire') + ' - ' + options[:category],
				description: I18n.t('tagline'),
				image: 'https://ratafire.com/assets/logo/screenshot.jpg'
			}
		else
			#With sub category
			#Normal meta tag
			set_meta_tags title: I18n.t('ratafire'),
						  description: I18n.t('tagline') + ' - ' + options[:category] + ' - ' + options[:sub_category],
						  image_src: 'https://ratafire.com/assets/logo/screenshot.jpg'
			#Open Graph Object
			set_meta_tags og: {
				title:    I18n.t('ratafire') + ' - ' + options[:category] + ' - ' + options[:sub_category],
				description: I18n.t('tagline'),
				type:     'website',
				image:    'https://ratafire.com/assets/logo/screenshot.jpg'
			}
			#Twitter Card
			set_meta_tags twitter: {
				card:  "summary_large_image",
				site: "ratafire.com",
				title: I18n.t('ratafire') + ' - ' + options[:category] + ' - ' + options[:sub_category],
				description: I18n.t('tagline'),
				image: 'https://ratafire.com/assets/logo/screenshot.jpg'
			}
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