class PendingSubscriptionApplicationsDatatable
  delegate :params, :h, :link_to, :user_path, :admin_subscription_applications_review_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: SubscriptionApplication.count,
      iTotalDisplayRecords: subscription_applications.total_entries,
      aaData: data
    }
  end

private

  def data
    subscription_applications.map do |subscription_application|
      [
        link_to(subscription_application.user.fullname,user_path(subscription_application.user_id),class:"no_ajaxify"),
        link_to("Review", admin_subscription_applications_review_path(subscription_application.id))
      ]
    end
  end

  def subscription_applications
    @subscription_applications ||= fetch_subscription_applications
  end

  def fetch_subscription_applications
    subscription_applications = SubscriptionApplication.where(:step => 7, :status => nil).order("#{sort_column} #{sort_direction}")
    subscription_applications = subscription_applications.page(page).per_page(per_page)
    if params[:sSearch].present?
      subscription_applications = subscription_applications.where("title like :search or user_id" , search: "%#{params[:sSearch]}%")
    end
    subscription_applications
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