class BlogpostsDatatable
  delegate :params, :h, :link_to, :time_ago_in_words,:edit_blog_post_path,:delete_blog_post_path,:user_path, :blog_post_path,:truncate, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Blogpost.count,
      iTotalDisplayRecords: blogposts.total_entries,
      aaData: data
    }
  end

private

  def data
    blogposts.map do |blogpost|
      [
        time_ago_in_words(blogpost.created_at)+" ago",
        link_to(blogpost.title,blog_post_path(blogpost.category,blogpost.id),class:"no_ajaxify"),
        link_to(blogpost.user.fullname,user_path(blogpost.user_id),class:"no_ajaxify"),
        blogpost.category,
        published(blogpost.published),
        link_to("Edit", edit_blog_post_path(blogpost.category,blogpost.id),class:"no_ajaxify"),
        link_to("Delete", delete_blog_post_path(blogpost.category,blogpost.id),class:"no_ajaxify")
      ]
    end
  end

  def blogposts
    @blogposts ||= fetch_blogposts
  end

  def fetch_blogposts
    blogposts = Blogpost.where(:deleted => false).order("#{sort_column} #{sort_direction}")
    blogposts = blogposts.page(page).per_page(per_page)
    if params[:sSearch].present?
      blogposts = blogposts.where("title like :search or user_id like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    blogposts
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title user_id category published]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def published(boolean)
    if boolean == true then
      return "Published"
    else
      return "Draft"
    end
  end

  def link(website)
      unless website[/\Ahttp:\/\//] || website[/\Ahttps:\/\//] then
        return "http://#{website}"
      else
        return website
      end
  end

end