class PendingPatronVideosDatatable
  delegate :params, :h, :link_to, :user_path, :admin_patron_videos_review_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: PatronVideo.where(:deleted => nil, :status => "Pending").count,
      iTotalDisplayRecords: patron_videos.total_entries,
      aaData: data
    }
  end

private

  def data
    patron_videos.map do |patron_video|
      [
        link_to(patron_video.user.fullname,user_path(patron_video.user_id),class:"no_ajaxify"),
        link_to("Review", admin_patron_videos_review_path(patron_video.id))
      ]
    end
  end

  def patron_videos
    @patron_videos ||= fetch_patron_videos
  end

  def fetch_patron_videos
    patron_videos = PatronVideo.where(:deleted => nil, :status => "Pending").order("#{sort_column} #{sort_direction}")
    patron_videos = patron_videos.page(page).per_page(per_page)
    if params[:sSearch].present?
      patron_videos = patron_videos.where("title like :search or user_id" , search: "%#{params[:sSearch]}%")
    end
    patron_videos
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[user_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end


end