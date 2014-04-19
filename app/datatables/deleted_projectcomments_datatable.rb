class DeletedProjectcommentsDatatable
  delegate :params, :h, :link_to, :restore_path, :truncate, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: ProjectComment.count,
      iTotalDisplayRecords: project_comments.total_entries,
      aaData: data
    }
  end

private

  def data
    project_comments.map do |project_comment|
      [
        truncate(project_comment.excerpt, :length => 100),
        link_to(truncate(project_comment.user.fullname, :length => 50), project_comment.user, class:"no_ajaxify"),
        link_to("Restore", restore_path("ProjectComment",project_comment.id), class:"no_ajaxify")
      ]
    end
  end

  def project_comments
    @project_comments ||= fetch_project_comments
  end

  def fetch_project_comments
    project_comments = ProjectComment.where(:deleted => true).order("#{sort_column} #{sort_direction}")
    project_comments = project_comments.page(page).per_page(per_page)
    if params[:sSearch].present?
      project_comments = project_comments.where("excerpt like :search", search: "%#{params[:sSearch]}%")
    end
    project_comments
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