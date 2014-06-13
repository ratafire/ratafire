class UsersDatatable
  delegate :params, :h, :link_to, :time_ago_in_words, :truncate, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.total_entries,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      [
        link_to(user.fullname,user,class:"no_ajaxify", target:"_blank"),
        user.username,
        user.email,
        user.tagline,
        user.projects.count,
        user.subscribers.count,
        user.subscribed.count,
        "Edit"
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per_page(per_page)
    if params[:sSearch].present?
      users = users.where("fullname like :search or username like :search or email like :search or website like :search", search: "%#{params[:sSearch]}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[fullname username email tagline projects subscribers subscribed]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end


  def link(website)
      unless website[/\Ahttp:\/\//] || website[/\Ahttps:\/\//] then
        return "http://#{website}"
      else
        return website
      end
  end

end