class Admin::MajorpostsController < ApplicationController

	#Before filters
	before_filter :load_majorpost
	before_filter :is_admin?	

	#NoREST Methods -----------------------------------	

	# set_featured_admin_majorposts
	# /admin/majorposts/set_featured/:majorpost_id
	def set_featured
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@activity.update(
				featured: true
			)
		end
	end

	# set_homepage_featured_admin_majorposts POST
	# /admin/majorposts/set_homepage_featured/:majorpost_id
	def set_homepage_featured
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@activity.update(
				featured_home: true
			)
		end
	end

	# set_test_admin_majorposts POST
	# /admin/majorposts/set_test/:majorpost_id
	def set_test
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@activity.update(
				test: true
			)
		end
	end

	# remove_admin_majorposts DELETE
	# /admin/majorposts/set_test/:majorpost_id/:option
	def remove
		if @activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
			@option = params[:option]
			case params[:option]
			when 'set_featured'
				@activity.update(
					featured: false
				)
			when 'set_homepage_featured'
				@activity.update(
					featured_home: false
				)
			when 'set_test'
				@activity.update(
					test: false
				)
			end
		end
	end

protected

	def load_majorpost
		@majorpost = Majorpost.find(params[:majorpost_id])
	end

	def is_admin?
		if current_user.admin != true
			redirect_to root_path
		end
	end	

end