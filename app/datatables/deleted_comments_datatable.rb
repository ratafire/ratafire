class DeletedCommentsDatatable
  delegate :params, :h, :link_to, :restore_path, :truncate, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Comment.count,
      iTotalDisplayRecords: comments.total_entries,
      aaData: data
    }
  end

private

  def data
    comments.map do |comment|
      [
        truncate(comment.excerpt, :length => 100),
        link_to(truncate(comment.user.fullname, :length => 50), comment.user, class:"no_ajaxify"),
        link_to("Restore", restore_path("Comment",comment.id), class:"no_ajaxify")
      ]
    end
  end

  def comments
    @comments ||= fetch_comments
  end

  def fetch_comments
    comments = Comment.where(:deleted => true).order("#{sort_column} #{sort_direction}")
    comments = comments.page(page).per_page(per_page)
    if params[:sSearch].present?
      comments = comments.where("excerpt like :search", search: "%#{params[:sSearch]}%")
    end
    comments
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[excerpt user]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end