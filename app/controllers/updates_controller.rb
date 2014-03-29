class UpdatesController < ApplicationController
	layout 'application'
	require 'will_paginate/array'

	def interesting
		@user = User.find(params[:id])
		#If subscribing anyone, route to subscribing
		if @user.subscribed.count > 0 then
			redirect_to subscribing_update_path(params[:id])
		else
			redirect_to followed_tags_path(params[:id])
		end
	end

	def subscribing_update #Only current user can see
		@user = current_user
		@subscribed = @user.subscribed
		gon.activebutton = "subscription"
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @subscribed, owner_type: "User").paginate(page: params[:subscribing], :per_page => 20)
	end

	#Show projects and majorposts under a specific tag
	def tags
		tag_tag
		@activities = PublicActivity::Activity.order("commented_at desc").tagged_with(params[:tag]).paginate(page: params[:page], :per_page => 20)
	end

	#Show tag followers
	def tag_followers #ajaxify in the future to increase speed
		tag_tag
		user = Array.new
		@tag.taggings.where(:taggable_type => "User").each do |t|
			user.push(User.find(t.taggable_id))
		end
		@followers = user.paginate(page: params[:page], :per_page => 32)
	end

	def followed_tags
		@user = current_user
		gon.activebutton = "followed_tags"
		@activities = PublicActivity::Activity.order("commented_at desc").tagged_with(@user.tag_list, :any => true).paginate(page: params[:subscribing], :per_page => 20)
	end

	def liked
		@user = current_user
		gon.activebutton = "liked"
		@activities = PublicActivity::Activity.order("created_at desc").tagged_with(@user.id.to_s, :on => :liker, :any => true).paginate(page: params[:subscribing], :per_page => 20)
	end

	def search
		@projects = Project.search(params[:search], page: 1, per_page: 20)
		@search = params[:search].titleize
		search_slug = params[:search].gsub(/\s/, "_")
		if search_slug == nil
			@wikipedialink = "http://en.wikipedia.org/wiki/" + params[:search]
		else
			@wikipedialink = "http://en.wikipedia.org/wiki/" + search_slug
		end		
	end

	def realm_selector
		case params[:realm]
		when "art"
			redirect_to art_path
		when "music"
			redirect_to music_path
		when "games"
			redirect_to games_path
		when "writing"
			redirect_to writing_path
		when "videos"
			redirect_to videos_path
		when "math"
			redirect_to math_path
		when "science"
			redirect_to science_path
		when "humanity"
			redirect_to humanity_path
		when "engineering"
			redirect_to engineering_path
		end
	end

	def art
		@user = current_user
		gon.activebutton = "art"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "art").paginate(page: params[:page], :per_page => 20)
	end

	def music
		@user = current_user
		gon.activebutton = "music"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "music").paginate(page: params[:page], :per_page => 20)
	end

	def games
		@user = current_user
		gon.activebutton = "games"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "games").paginate(page: params[:page], :per_page => 20)
	end	

	def writing
		@user = current_user
		gon.activebutton = "writing"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "writing").paginate(page: params[:page], :per_page => 20)
	end

	def videos
		@user = current_user
		gon.activebutton = "videos"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "videos").paginate(page: params[:page], :per_page => 20)
	end	

	def math
		@user = current_user
		gon.activebutton = "math"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "math").paginate(page: params[:page], :per_page => 20)
	end		

	def science
		@user = current_user
		gon.activebutton = "science"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "science").paginate(page: params[:page], :per_page => 20)
	end			

	def humanity
		@user = current_user
		gon.activebutton = "humanity"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "humanity").paginate(page: params[:page], :per_page => 20)
	end			

	def engineering
		@user = current_user
		gon.activebutton = "engineering"
		@activities = PublicActivity::Activity.order("commented_at desc").where(realm: "engineering").paginate(page: params[:page], :per_page => 20)
	end			

	def featured
		@user = current_user
		gon.activebutton = "staffpicks"
		@activities = PublicActivity::Activity.order("commented_at desc").where(featured: true).paginate(page: params[:page], :per_page => 20)
	end

	def all
		@user = current_user
		gon.activebutton = "all"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Majorpost","Project"]).paginate(page: params[:page], :per_page => 20)
	end		

private
	
	#Check if the current user is following this tag
	def	following_tag?(name) 
		if current_user.tag_list.include? name then
			@following = true
		else
			@following = false
		end
	end

	#Repeated part of tags and tag_followers
	def tag_tag
		@tag = ActsAsTaggableOn::Tag.find_by_name(params[:tag])
		@tag_name = @tag.name.titleize
		name = @tag_name
		tag_name_slug = name.gsub(/\s/, "_")
		#Follower count
		@follower_count = @tag.taggings.where(:taggable_type => "User").count
		#Check if the current user is following this tag
		following_tag?(@tag.name)
		if @tag_name_slug == nil
			@wikipedialink = "http://en.wikipedia.org/wiki/" + @tag.name
		else
			@wikipedialink = "http://en.wikipedia.org/wiki/" + tag_name_slug
		end	
	end 

end