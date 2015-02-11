class PendingDiscussionsDatatable
  delegate :params, :h, :link_to, :show_discussion_path,:user_path, :admin_discussion_review_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Discussion.count,
      iTotalDisplayRecords: discussions.total_entries,
      aaData: data
    }
  end

private

  def data
    discussions.map do |discussion|
      [
        link_to(discussion.title,show_discussion_path(discussion.id),class:"no_ajaxify"),
        link_to(discussion.creator.fullname,user_path(discussion.creator_id),class:"no_ajaxify"),
        discussion.realm,
        discussion.sub_realm,
        link_to("Review", admin_discussion_review_path(discussion.id))
      ]
    end
  end

  def discussions
    @discussions ||= fetch_discussions
  end

  def fetch_discussions
    discussions = Discussion.where(:published => true, :deleted => false, :reviewed_at => nil).order("#{sort_column} #{sort_direction}")
    discussions = discussions.page(page).per_page(per_page)
    if params[:sSearch].present?
      discussions = discussions.where("title like :search or creator_id like :search or realm like :search " , search: "%#{params[:sSearch]}%")
    end
    discussions
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title creator_id realm sub_realm]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end


end