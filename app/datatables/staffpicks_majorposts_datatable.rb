class StaffpicksMajorpostsDatatable
  delegate :params, :h, :link_to, :user_project_majorpost_path, :majorpost_staff_picks_delete_path, :truncate, to: :@views

  def initialize(views)
    @views = views
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Majorpost.count,
      iTotalDisplayRecords: majorposts.total_entries,
      aaData: data
    }
  end

private

  def data
    majorposts.map do |majorpost|
      [
        link_to(truncate(majorpost.title, :length => 50), user_project_majorpost_path(majorpost.project.creator,majorpost.project, majorpost), class:"no_ajaxify"),
        link_to(truncate(majorpost.user.fullname, :length => 50), majorpost.user, class:"no_ajaxify"),
        link_to("Unpick", majorpost_staff_picks_delete_path(majorpost.id), class:"no_ajaxify")
      ]
    end
  end

  def majorposts
    @majorposts ||= fetch_majorposts
  end

  def fetch_majorposts
    majorposts = Majorpost.where(:featured => true).order("#{sort_column} #{sort_direction}")
    majorposts = majorposts.page(page).per_page(per_page)
    if params[:sSearch].present?
      majorposts = majorposts.where("title like :search and user like :search", search: "%#{params[:sSearch]}%")
    end
    majorposts
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title user_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end