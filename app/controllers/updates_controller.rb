class UpdatesController < ApplicationController
	layout 'application'
	require 'will_paginate/array'

	before_filter :check_for_mobile
  	before_filter :user_sign_up_complete 
	before_filter :signed_in_user, 
				only: [:subscribing_update, :followed_tags, :liked, :watched]

	def interesting
		if user_signed_in? then
			@user = User.find(params[:id])
			#If subscribing anyone, route to subscribing
			if @user.subscribed.count > 0 then
				redirect_to subscribing_update_path(params[:id])
			else
				redirect_to followed_tags_path(params[:id])
			end
		else
			redirect_to new_user_session_path
		end	
	end

	def subscribing_update #Only current user can see
		@user = current_user
		@subscribed = @user.subscribed
		gon.activebutton = "subscription"
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @subscribed, owner_type: "User", trackable_type: ["Majorpost","Project","Comment","Facebookupdate"], :test => false).paginate(page: params[:subscribing], :per_page => 20)
	end

	#Show projects and majorposts under a specific tag
	def tags
		tag_tag
		@activities = PublicActivity::Activity.order("commented_at desc").where(:draft => false, :test => false, :abandoned => nil).tagged_with(params[:tag]).paginate(page: params[:page], :per_page => 20)
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
		@activities = PublicActivity::Activity.order("commented_at desc").tagged_with(@user.tag_list, :any => true, :draft => false, :test => false, :abandoned => nil).paginate(page: params[:subscribing], :per_page => 20)
	end

	def liked
		@user = current_user
		gon.activebutton = "liked"
		@activities = PublicActivity::Activity.order("created_at desc").tagged_with(@user.id.to_s, :on => :liker, :any => true, :test => false).paginate(page: params[:subscribing], :per_page => 20)
	end

	def search
		@projects = Project.search(params[:search], page: 1, per_page: 20, conditions: {published: 1, :deleted => nil}).paginate(page: params[:page], :per_page => 20)
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
		gon.activebutton = "art"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "art", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end

	def music
		gon.activebutton = "music"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "music", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end

	def games
		gon.activebutton = "games"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "games", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end	

	def writing
		gon.activebutton = "writing"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "writing", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end

	def videos
		gon.activebutton = "videos"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "videos", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end	

	def math
		gon.activebutton = "math"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "math", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end		

	def science
		gon.activebutton = "science"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "science", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end			

	def humanity
		gon.activebutton = "humanity"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "humanity", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end			

	def engineering
		gon.activebutton = "engineering"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"],realm: "engineering", :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end			

	def featured
		gon.activebutton = "staffpicks"
		@activities = PublicActivity::Activity.order("commented_at desc").where(:featured => true).paginate(page: params[:page], :per_page => 20)
		if user_signed_in? then
			#Redirect to Tutorial if Null
			if current_user.tutorial.intro == nil then
				if current_user.tutorial.facebook == nil then
					redirect_to user_omniauth_authorize_path(:facebook, after_signup: "true")
				else
					current_user.tutorial.update_column(:intro, true)
					redirect_to intro_tutorial_path(current_user)
				end
			end
		end
	end

	def all
		gon.activebutton = "all"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project", "Discussion"], :draft => false, :test => false, :abandoned => nil).paginate(page: params[:page], :per_page => 20)
	end		

	def test
		gon.activebutton = "test"
		@activities = PublicActivity::Activity.order("commented_at desc").where(trackable_type: ["Facebookupdate","Majorpost","Project","Discussion"], :draft => false, :test => true).paginate(page: params[:page], :per_page => 20)
	end

	def watched
		@user = current_user
		@activities = PublicActivity::Activity.order("created_at desc").tagged_with(@user.id.to_s, :on => :watcher, :any => true, :test => false).paginate(page: params[:subscribing], :per_page => 20)
	end

	def fundable
		@users = User.where(:subscription_status_initial => "Approved").paginate(page: params[:fundable], :per_page => 99)
	end

	def genius
	end

	def challenges
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
		if signed_in? 
			following_tag?(@tag.name)
			if @tag_name_slug == nil
				@wikipedialink = "http://en.wikipedia.org/wiki/" + @tag.name
			else
				@wikipedialink = "http://en.wikipedia.org/wiki/" + tag_name_slug
			end	
		end	
	end 

  	#Devise 
    def current_user?(user)
      user == current_user
    end

  	#See if the user is signed in?
    def signed_in_user
      unless signed_in?
        redirect_to new_user_session_path, notice:"Please sign in." unless signed_in?
      end
    end   

  def user_sign_up_complete
  	if user_signed_in? then
    	if current_user.need_username == true then
     	 	@subscription_first = Subscription.where(:deleted => false, :activated => true, :subscriber_id => current_user.id).first
      		redirect_to subscription_thank_you_path(@subscription_first.id)
    	end
    end
  end    
end