class BlogpostsController < ApplicationController
	layout "application"
	before_filter :admin_user, only: [:edit,:select,:create,:update,:delete]

	def show
		@blogpost = Blogpost.where(:published => true, :deleted => false).paginate(page: params[:page], :per_page => 10)
	end
	
	def edit
		@blogpost = Blogpost.find(params[:id])
	end

	def single
		@blogpost = Blogpost.find(params[:id])
	end

	def update
		@blogpost = Blogpost.find(params[:id])
		@blogpost.excerpt = Sanitize.clean(@blogpost.content)
			if @blogpost.update_attributes(params[:blogpost]) then
				
				if @blogpost.published == false
					flash[:success] = "You updated the draft!"
				else
					flash[:success] = "You updated the post!"
				end
			end
			redirect_to admin_blog_path 
	end

	def select
		respond_to do |format|
    		format.html
    		format.json { render json: BlogpostsDatatable.new(view_context) }
  		end
	end

	def create
		@blogpost = Blogpost.new()
		@blogpost.user = current_user
		@blogpost.title = blogpost_draft_title
		@blogpost.published = false
		@blogpost.category = params[:category]
		if @blogpost.save then
			redirect_to edit_blog_post_path(params[:category],@blogpost)
		else
			redirect_to(:back)
		end
	end

	def delete
		@blogpost = Blogpost.find(params[:id])
		@blogpost.deleted = true
		@blogpost.deleted_at = Time.now
		@blogpost.save
		redirect_to(:back)
		flash[:success] = "Blog post deleted!"
	end

	def new_features
		@blogpost = Blogpost.where(:published => true, :deleted => false, :category => "new-features").paginate(page: params[:page], :per_page => 10)
	end

	def engineering
		@blogpost = Blogpost.where(:published => true, :deleted => false, :category => "engineering").paginate(page: params[:page], :per_page => 10)
	end

	def design
		@blogpost = Blogpost.where(:published => true, :deleted => false, :category => "design").paginate(page: params[:page], :per_page => 10)
	end

	def news
		@blogpost = Blogpost.where(:published => true, :deleted => false, :category => "news").paginate(page: params[:page], :per_page => 10)
	end

	def category_selector
		case params[:category]
		when "new-features"
			redirect_to blog_new_features_path
		when "engineering"
			redirect_to blog_engineering_path
		when "design"
			redirect_to blog_design_path
		when "news"
			redirect_to blog_news_path
		end
	end

private

	def blogpost_draft_title
		time = DateTime.now.strftime("%H:%M:%S").to_s
		title = "New Blog Post" + time
		return title	
	end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


end