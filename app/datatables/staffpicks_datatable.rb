class StaffpicksDatatable
  delegate :params, :h, :link_to, :user_project_path, :project_staff_picks_delete_path, :truncate, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Project.count,
      iTotalDisplayRecords: projects.total_entries,
      aaData: data
    }
  end

private

  def data
    projects.map do |project|
      [
        link_to(truncate(project.title, :length => 50), user_project_path(project.creator, project), class:"no_ajaxify"),
        link_to(truncate(project.creator.fullname, :length => 50), project.creator, class:"no_ajaxify"),
        link_to("Unpick", project_staff_picks_delete_path(project.id), class:"no_ajaxify")
      ]
    end
  end

  def projects
    @projects ||= fetch_projects
  end

  def fetch_projects
    projects = Project.where(:featured => true).order("#{sort_column} #{sort_direction}")
    projects = projects.page(page).per_page(per_page)
    if params[:sSearch].present?
      projects = projects.where("title like :search", search: "%#{params[:sSearch]}%")
    end
    projects
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title creator]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end