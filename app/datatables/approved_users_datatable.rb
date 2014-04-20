class ApprovedUsersDatatable
  delegate :params, :h, :link_to, :beta_approve_path, :beta_ignore_path, :time_ago_in_words, :truncate, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: BetaUser.count,
      iTotalDisplayRecords: beta_users.total_entries,
      aaData: data
    }
  end

private

  def data
    beta_users.map do |beta_user|
      [
        heart(beta_user.creator),
        beta_user.fullname,
        beta_user.username,
        beta_user.email,
        link_to(beta_user.website,link(beta_user.website),class:"no_ajaxify", target:"_blank"),
        beta_user.realm,
        time_ago_in_words(beta_user.created_at),
        link_to("Approve", beta_approve_path(beta_user),class:"no_ajaxify"),
        link_to("Ignore", beta_ignore_path(beta_user),class:"no_ajaxify")
      ]
    end
  end

  def beta_users
    @beta_users ||= fetch_beta_users
  end

  def fetch_beta_users
    beta_users = BetaUser.where(:approved => true).order("#{sort_column} #{sort_direction}")
    beta_users = beta_users.page(page).per_page(per_page)
    if params[:sSearch].present?
      beta_users = beta_users.where("fullname like :search or username like :search or email like :search or website like :search or realm like :search", search: "%#{params[:sSearch]}%")
    end
    beta_users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[fullname username email website realm]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def heart(boolean)
    if boolean == true then
      return "Y"
    else
      return ""
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