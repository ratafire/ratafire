class CampaignsDatatable
	delegate :params, :t, :link_to, :image_tag, :review_admin_campaigns_path, :profile_url_path, to: :@view

    def initialize(view)
    @view = view
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Campaign.count,
      iTotalDisplayRecords: campaigns.total_entries,
      aaData: data
    }
    end

private

    def data
        campaigns.map do |campaign|
          [
            campaign.id,
            image_tag(campaign.image.url(:thumbnail64)),
            campaign.title,
            link_to(campaign.user.fullname, profile_url_path(campaign.user.username)),
            campaign.category,
            campaign.sub_category,
            link_to(t('views.utilities.editor.review'), review_admin_campaigns_path(campaign.id))
          ]
        end
    end

    def campaigns
        @campaigns ||= fetch_campaigns
    end

    def fetch_campaigns
        campaigns = Campaign.where(:review_status => "Pending").order("#{sort_column} #{sort_direction}")
        campaigns = campaigns.page(page).per_page(per_page)
        if params[:sSearch].present?
          campaigns = campaigns.where("title like :search or user_id like :search or category like :search or sub_category like :search", search: "%#{params[:sSearch]}%")
        end
        campaigns
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[id title user_id category sub_category]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end