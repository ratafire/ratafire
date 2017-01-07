class Explore::TagsController < ApplicationController

	layout 'profile'

	#Before filters
	before_filter :load_tag, only:[:tags]
	before_filter :load_tag_by_id, except:[:tags, :followed_pagination]
	before_filter :authenticate_user!, except:[:tags]		
	before_filter :load_user
	before_filter :show_followed, only:[:tags]

	#REST Methods -----------------------------------

	#NoREST Methods -----------------------------------
	
	# tag GET
	# /tags/:tag
	def tags
		@activities = PublicActivity::Activity.order("created_at desc").where(:test => false, :abandoned => nil,trackable_type: ["Campaign","Majorpost"]).tagged_with(params[:tag]).paginate(page: params[:page], :per_page => 5)
	end	

	# explore_tag_follow POST
	# /explore/tags/:tag_id/follow
	def follow
		@user.tag_list.add(@tag.name)
		@user.save
	end

	# explore_tag_unfollow DELETE
	# /explore/tags/:tag_id/unfollow
	def unfollow
		@user.tag_list.remove(@tag.name)
		@user.save		
	end

	# followed_pagination get
	def followed_pagination
	end

protected

	def load_tag
		unless @tag = ActsAsTaggableOn::Tag.find_by_name(params[:tag])
			@tag = ActsAsTaggableOn::Tag.find(params[:tag])
		end
		#Find the first 5 followers
		user = Array.new
		if @tag.taggings.where(:taggable_type => "User").order("created_at desc").count > 0
			@tag.taggings.where(:taggable_type => "User").order("created_at desc")[0..4].each do |t|
				user.push(User.find(t.taggable_id))
			end
		end
		@followers = user
	end

	def load_tag_by_id
		@tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
	end

	def load_user
		if user_signed_in?
			@user = current_user
			if @tag
				following_tag?(@tag.name)
			end
		end
	end

	def	following_tag?(name) 
		if @user.tag_list.include? name then
			@following = true
		else
			@following = false
		end
	end

	def show_followed
		if user_signed_in?
			@followed = current_user.likeds.order("last_seen desc").page(params[:followed_update]).per_page(3)
		end
	end

end