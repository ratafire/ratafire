class AdminController < ApplicationController
	layout 'application'
	before_filter :admin_user

	def test
	end

	def content
	end

	def main
		@quote = Quote.offset(rand(Quote.count)).first
	end

	def users
		@user = User.paginate(page: params[:page], :per_page => 50)
		@quote = Quote.offset(rand(Quote.count)).first
		@goal = @user.count.to_f / 1000.to_f * 100
	end

	def discussion
	end

	def discussion_review_update
		@review = Review.new(params[:review])
		#Save the Review
		if @review.save 
			#Change the Status of the Discussion
			@discussion = Discussion.find(@review.discussion_id)
			@discussion.reviewed_at = Time.now
			@discussion.review_status = @review.status
			@discussion.save 
			#Send Message
			@receiver = User.find(@discussion.creator_id)
			#If Approved
			if @review.status == "Approved" then
				#Send Message
				@message_content = "<p>Your discussion is approved. </p><p>"+@review.content+"</p><p>You can view your discussion via this link: <a class='no_ajaxify' target='_blank' href=\"https://www.ratafire.com/"+@discussion.id.to_s+"/r/discussion/show\">"+@discussion.title+"</a>." 
				@message_title = "Your Discussion: "+@discussion.title+" is Approved"
				@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@discussion.id,'Discussion')
				if @activity != nil then
					@activity.draft = false
					@activity.save
				end
			else
				#Send Message
				@message_title = "Your Discussion: "+@discussion.title+" is Disapproved."
				@message_content ="<p>Your discussion is disapproved.</p><p>"+@review.content+"</p><p>You can view your discussion via this link: <a class=\"no_ajaxify\" target=\"_blank\" href=\"https://www.ratafire.com/"+@discussion.id.to_s+"/r/discussion/show\">"+@discussion.title+"</a>. You can edit your discussion to apply again or delete it. Thank you."
				@discussion.published = false
				@discussion.save
			end
			receipt = current_user.send_message(@receiver, @message_content, @message_title)
			#Send Email
			DiscussionReviewMailer.discussion_review(@discussion.id,@review.id,@message_content,@message_title).deliver
		end
		#Send Email
		redirect_to admin_discussion_path
	end

	def discussion_review
		@discussion = Discussion.find(params[:id])
		@review = Review.new()
	end

	def subscription
	end

	def patron_video
	end

	def facebookupdate
		@activities = PublicActivity::Activity.order("created_at desc").where(trackable_type: ["Facebookupdate"], :test => true).paginate(page: params[:page], :per_page => 20)
	end

	def homepage_featured
		@activities = PublicActivity::Activity.order("commented_at desc").where(:featured_home => true).paginate(page: params[:page], :per_page => 20)
	end

	def subscription_applications_review
		@subscription_application = SubscriptionApplication.find(params[:id])
		@project = @subscription_application.user.projects.where(:published => true, :complete => false, :abandoned => false).first
		@discussion =@subscription_application.user.discussions.where(:published => true, :review_status => "Approved", :deleted => false).first
		@review = Review.new()
	end

	def subscription_application_review_update
		@review = Review.new(params[:review])
		#Save the Review
		if @review.save 
			#Change the Status of the Discussion
			@subscription_application = SubscriptionApplication.find(@review.subscription_application_id)
			@subscription_application.status = @review.status
			@subscription_application.save 
			#Send Message
			@receiver = User.find(@subscription_application.user_id)
			#If Approved
			if @review.status == "Approved" then
				#Make the user subscription status be on
				@receiver.subscription_status_initial = "Approved"
				#Map Subscription Info
				@receiver.why = @subscription_application.why
				@receiver.plan = @subscription_application.plan
				@receiver.goals_subscribers = @subscription_application.goals_subscribers
				@receiver.goals_monthly = @subscription_application.goals_monthly
				@receiver.goals_project = @subscription_application.goals_project
				@receiver.save
				#Set project
				if @subscription_application.project_id != nil then 
					@project = Project.find(@subscription_application.project_id)
					if @project != nil then 
						@project.collectible = @subscription_application.collectible
						@project.save
					end
				else
					#Set Facebook Page
					if @subscription_application.facebookpage_id != nil then 
						@facebookpage = Facebookpage.find(@subscription_application.facebookpage_id)
						if @facebookpage != nil then 
							@facebookpage.collectible = @subscription_application.collectible
							@facebookpage.save
						end
					end
				end
				#Send Message
				@message_content = "<p>Your application is approved. </p><p>"+@review.content+"</p><p>You can view your quest board via <a class='no_ajaxify' target='_blank' href=\"https://www.ratafire.com/"+@receiver.username.to_s+"\">this link</a>. "
				@message_title = "You can now accept patrons"
				#Set the time bomb
				@subscription_application.approved_at = Time.now
				@subscription_application.completed_at = Time.now + 15.days
				@subscription_application.save
				if @review.skip_countdown == true then
					@subscription_application.completion = true
					@subscription_application.save
				else
					Resque.enqueue_in(15.day,SubscriptionTimebombWorker,@receiver.id)
				end
			else
				#Send Message
				@message_title = "Your Application is Disapproved"
				@message_content ="<p>Your application is disapproved.</p><p>"+@review.content+"</p><p>You can re-apply via <a class=\"no_ajaxify\" target=\"_blank\" href=\"https://www.ratafire.com/"+@receiver.username.to_s+"/r/settings/payment\">this link</a>. Thank you."
			end
			receipt = current_user.send_message(@receiver, @message_content, @message_title)
			#Send Email
			SubscriptionApplicationReviewMailer.subscription_application_review(@subscription_application.id,@review.id,@message_content,@message_title).deliver
		end
		#Send Email
		redirect_to admin_subscription_path		
	end

	def content_users
		respond_to do |format|
    		format.html
    		format.json { render json: UsersDatatable.new(view_context) }
  		end				
	end

	def content_project
		respond_to do |format|
    		format.html
    		format.json { render json: StaffpicksDatatable.new(view_context) }
  		end		
	end

	def content_majorpost
		respond_to do |format|
    		format.html
    		format.json { render json: StaffpicksMajorpostsDatatable.new(view_context) }
  		end		
	end

	def content_deleted_project
		respond_to do |format|
    		format.html
    		format.json { render json: DeletedProjectsDatatable.new(view_context) }
  		end	
	end

	def content_deleted_majorpost
		respond_to do |format|
    		format.html
    		format.json { render json: DeletedMajorpostsDatatable.new(view_context) }
  		end	
	end	

	def content_deleted_comment
		respond_to do |format|
    		format.html
    		format.json { render json: DeletedCommentsDatatable.new(view_context) }
  		end	
	end		

	def content_deleted_project_comment
		respond_to do |format|
    		format.html
    		format.json { render json: DeletedProjectcommentsDatatable.new(view_context) }
  		end	
	end		

	def test_projects
		respond_to do |format|
    		format.html
    		format.json { render json: TestProjectsDatatable.new(view_context) }
  		end	
	end		

	def test_majorposts
		respond_to do |format|
    		format.html
    		format.json { render json: TestMajorpostsDatatable.new(view_context) }
  		end	
	end		

	def pending_discussions
		respond_to do |format|
    		format.html
    		format.json { render json: PendingDiscussionsDatatable.new(view_context) }
  		end		
	end		

	def pending_subscription_applications
		respond_to do |format|
    		format.html
    		format.json { render json: PendingSubscriptionApplicationsDatatable.new(view_context) }
  		end				
	end



	#This is a test for Resque workder: TestWorker
	def test_resque
		Facebook.find_each do |facebook|
			user = User.find(facebook.user_id)
			if user != nil then 
				if user.fullname != facebook.name then
					user.update_attribute(:fullname,facebook.name)
				end
			end
		end
		redirect_to(:back)
	end

	#This is for adding tests
	def add_tests
		url = params[:url]
		if url != nil then
			#See if it is an internal link

				splitted = url.split("/")
				@project_slug = splitted[4]
				@majorpost_slug = splitted[5]

				#get model
				@project = Project.find_by_perlink(@project_slug)
				@majorpost = Majorpost.find_by_slug(@majorpost_slug)

				#Do the work
				#Project
				if @project != nil && @majorpost == nil then
					@project.test = true 
					@project.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
					if @activity != nil then
						@activity.test = true
						@activity.save
					end
					flash[:success] = "You tested "+@project.title+" !"	
				end

				#Majorpost
				if @project != nil && @majorpost != nil then
					@majorpost.test = true
					@majorpost.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
					if @activity != nil then
						@activity.test = true
						@activity.save
					end
					flash[:success] = "You tested "+@majorpost.title+" !"							
				end

		else
			flash[:success] = "No url!"			
		end	
		redirect_to(:back)
	end

	#This handles the request for Feature Projects
	def staff_pick
		url = params[:url]
		if url != nil then
			#See if it is an internal link

				splitted = url.split("/")
				@project_slug = splitted[4]
				@majorpost_slug = splitted[5]

				#get model
				@project = Project.find_by_perlink(@project_slug)
				@majorpost = Majorpost.find_by_slug(@majorpost_slug)

				#Do the work
				#Project
				if @project != nil && @majorpost == nil then
					@project.featured = true 
					@project.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
					if @activity != nil then
						@activity.featured = true
						@activity.save
					end
					flash[:success] = "You featured "+@project.title+" !"	
				end

				#Majorpost
				if @project != nil && @majorpost != nil then
					@majorpost.featured = true
					@majorpost.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
					if @activity != nil then
						@activity.featured = true
						@activity.save
					end
					flash[:success] = "You featured "+@majorpost.title+" !"							
				end

		else
			flash[:success] = "No url!"			
		end	
		redirect_to(:back)
	end

	#This is the request to delete project staffpicks
	def project_staff_picks_delete
		@project = Project.find(params[:project_id])
		@project.featured = nil
		@project.save

		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
		if @activity != nil then
			@activity.featured = nil
			@activity.save
		end

		flash[:success] = "You unpicked "+@project.title+" !"
		redirect_to(:back)
	end

	#This is the request to delete majorpost staffpicks
	def majorpost_staff_picks_delete
		@majorpost = Majorpost.find(params[:majorpost_id])
		@majorpost.featured = nil
		@majorpost.save

		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
		if @activity != nil then
			@activity.featured = nil
			@activity.save
		end

		flash[:success] = "You unpicked "+@majorpost.title+" !"
		redirect_to(:back)
	end	

	def organization
	end

	#This handles the deletion of content
	def delete_content
		url = params[:url]
		if url != nil then
				splitted = url.split("/")
				#See if this is a comment
				if splitted[4] == "projects" then
					@project_slug = splitted[5]
					#See if this is a project comment
					unless splitted[6] == "project_comments" then
						@majorpost_slug = splitted[7]
						@comment_id = splitted[9]
					else
						@project_comment_id = splitted[7]
					end
				else
					@project_slug = splitted[4]
					@majorpost_slug = splitted[5]	
				end	

				#Do the work
				#Project
				if @project_slug != nil && @majorpost_slug == nil && @project_comment_id == nil then
					@project = Project.find_by_perlink(@project_slug)
					@project.deleted = true
					@project.deleted_at = Time.now
					@project.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project.id,'Project')
					if @activity != nil then
						@activity.deleted = true
						@activity.deleted_at = Time.now
						@activity.save
					end
					flash[:success] = "You deleted project "+@project.title+" !"
				end

				#Majorpost
				if @project_slug != nil && @majorpost_slug != nil && @comment_id == nil then
					@majorpost = Majorpost.find_by_slug(@majorpost_slug)
					@majorpost.deleted = true
					@majorpost.deleted_at = Time.now
					@majorpost.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@majorpost.id,'Majorpost')
					if @activity != nil then
						@activity.deleted = true
						@activity.deleted_at = Time.now
						@activity.save
					end
					flash[:success] = "You deleted majorpost "+@majorpost.title+" !"
				end

				#Comment
				if @comment_id != nil then
					@comment = Comment.find(@comment_id)
					@comment.deleted = true
					@comment.deleted_at = Time.now
					@comment.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@comment.id,'Comment')
					if @activity != nil then
						@activity.deleted = true
						@activity.deleted_at = Time.now
						@activity.save
					end
					flash[:success] = "You deleted comment "+@comment.id.to_s+" !"					
				end

				#Project Comment
				if @project_comment_id != nil then
					@project_comment = ProjectComment.find(@comment_id)
					@project_comment.deleted = true
					@project_comment.deleted_at = Time.now
					@project_comment.save

					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@project_comment.id,'ProjectComment')
					if @activity != nil then
						@activity.deleted = true
						@activity.deleted_at = Time.now
						@activity.save
					end
					flash[:success] = "You deleted project comment "+@project_comment.id.to_s+" !"							
				end

		end
		redirect_to(:back)
	end

	#This is for restoring content
	def restore
		if params[:type] == "Project" then
			@project = Project.find_by_deleted_and_id(true,params[:id])
			@project.deleted = false
			@project.deleted_at = nil
			@project.save
			flash[:success] = "You restored project "+@project.title+" !"
		else
			if params[:type] == "Majorpost" then
				@majorpost = Majorpost.find_by_deleted_and_id(true,params[:id])
				@majorpost.deleted = false
				@majorpost.deleted_at = nil
				@majorpost.save
				flash[:success] = "You restored majorpost "+@majorpost.title+" !"
			else
				if params[:type] == "Comment" then
					@comment = Comment.find_by_deleted_and_id(true,params[:id])
					@comment.deleted = false
					@comment.deleted_at = nil
					@comment.save
					flash[:success] = "You restored comment "+@comment.id.to_s+" !"
				else
					if params[:type] == "ProjectComment" then
						@project_comment = ProjectComment.find_by_deleted_and_id(true,params[:id])
						@project_comment.deleted = false
						@project_comment.deleted_at = nil
						@project_comment.save
						flash[:success] = "You restored project comment "+@project_comment.id.to_s+" !"
					end
				end
			end
		end
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:id],params[:type])
		if @activity != nil then
			@activity.deleted = false
			@activity.deleted_at = nil
			@activity.save
		end
		redirect_to(:back)
	end

	#This is for untest
	def untest
		if params[:type] == "Project" then
			@project = Project.find_by_test_and_id(true,params[:id])
			@project.test = false
			@project.save
			flash[:success] = "You untested project "+@project.title+" !"
		else
			if params[:type] == "Majorpost" then
				@majorpost = Majorpost.find_by_test_and_id(true,params[:id])
				@majorpost.test = false
				@majorpost.save
				flash[:success] = "You untested majorpost "+@majorpost.title+" !"
			end
		end
		@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(params[:id],params[:type])
		if @activity != nil then
			@activity.test = false
			@activity.save
		end
		redirect_to(:back)		
	end
	
	#This is to feature something
	def admin_actions
		case params[:type]
			when "Project"
				@object = Project.find(params[:id])
			when "Majorpost"
				@object = Majorpost.find(params[:id])
			when "Discussion"
				@object = Discussion.find(params[:id])
			when "Facebookupdate"
				@object = Facebookupdate.find(params[:id])
		end
		if @object != nil then
			case params[:actionname]
				when "featured"
					@object.update_column(:featured, true)
					@object.update_column(:test, false)
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.featured = true
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Featured."
					redirect_to(:back)
				when "featuredhome"
					@object.update_column(:featured, true)
					@object.update_column(:featured_home, true)
					@object.update_column(:test, false)
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.featured = true
						@activity.featured_home = true
						@activity.test = false
						@activity.draft = false
						@activity.save
					end				
					flash[:success] = "Added to Homepage."
					redirect_to(:back)	
				when "test"
					@object.update_column(:test, true)
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.test = true
						@activity.save
					end		
					flash[:success] = "Unlisted."
					redirect_to(:back)	
				when "untest"
					@object.update_column(:test, false)
					@object.update_column(:featured_home, false)
					@object.update_column(:test, false)							
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.test = false
						@activity.draft = false
						@activity.save
					end			
					flash[:success] = "Listed."
					redirect_to(:back)	
				when "unfeature"
					@object.update_column(:featured_home, false)
					@object.update_column(:test, true)					
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.featured = false
						@activity.save
					end	
					flash[:success] = "Unfeatured."
					redirect_to(:back)
				when "unfeaturehome"
					@object.update_column(:featured_home, false)
					@object.update_column(:test, true)					
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.featured_home = false
						@activity.save
					end	
					flash[:success] = "Unfeatured from homepage"
					redirect_to(:back)													
			end
		end
	end

	def add_admin_realm
		case params[:type]
			when "Project"
				@object = Project.find(params[:id])
			when "Majorpost"
				@object = Majorpost.find(params[:id])
			when "Discussion"
				@object = Discussion.find(params[:id])
			when "Facebookupdate"
				@object = Facebookupdate.find(params[:id])
		end
		if @object != nil then
			case params[:realmname]
				when "1"
					@object.update_column(:test, false)
					@object.update_column(:realm, "art")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false						
						@activity.save
					end
					flash[:success] = "Added to Art."
					redirect_to(:back)
				when "2"
					@object.update_column(:test, false)
					@object.update_column(:realm, "music")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Added to Music."
					redirect_to(:back)
				when "3"
					@object.update_column(:test, false)
					@object.update_column(:realm, "games")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Added to Games."
					redirect_to(:back)
				when "4"
					@object.update_column(:test, false)
					@object.update_column(:realm, "writing")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Added to Writing."
					redirect_to(:back)
				when "5"
					@object.update_column(:test, false)
					@object.update_column(:realm, "videos")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Added to Videos."
					redirect_to(:back)	
				when "6"
					@object.update_column(:test, false)
					@object.update_column(:realm, "math")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Added to Math."
					redirect_to(:back)		
				when "7"
					@object.update_column(:test, false)
					@object.update_column(:realm, "science")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Added to Science."
					redirect_to(:back)		
				when "8"
					@object.update_column(:test, false)
					@object.update_column(:realm, "humanity")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Added to Humanity."
					redirect_to(:back)		
				when "9"
					@object.update_column(:test, false)
					@object.update_column(:realm, "engineering")
					@activity = PublicActivity::Activity.find_by_trackable_id_and_trackable_type(@object.id,params[:type])
					if @activity != nil then
						@activity.realm = @object.realm
						@activity.test = false
						@activity.draft = false
						@activity.save
					end
					flash[:success] = "Added to Engineering."
					redirect_to(:back)																														
			end
		end		
	end

private

	def admin_user
      redirect_to(root_url) unless current_user.admin?
    end	

end