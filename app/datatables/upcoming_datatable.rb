class UpcomingDatatable
    delegate :params, :t, :link_to, :image_tag, :category_color,:currency_signs, :number_to_currency, :unsub_user_payment_subscriptions_path,:raw,:profile_url_path, :is_category, to: :@view

    def initialize(view)
    	@view = view
    	@user = User.find(params[:user_id])
    	@order = @user.order
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: OrderSubset.where(:order_id => @order.id, :deleted => nil, :transacted => nil).count,
      iTotalDisplayRecords: order_subsets.total_entries,
      aaData: data
    }
    end

private

    def data
        order_subsets.map do |order_subset|
          [
            link_to(image_tag(User.find(order_subset.subscribed_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(order_subset.subscribed_id).username),target:"_blank"),
            link_to(User.find(order_subset.subscribed_id).preferred_name, profile_url_path(User.find(order_subset.subscribed_id).username),target:"_blank"),
            link_to(User.find(order_subset.subscribed_id).try(:active_campaign).try(:title), profile_url_path(User.find(order_subset.subscribed_id).username),target:"_blank"),
            '<span class="label '+ category_color(User.find(order_subset.subscribed_id).active_campaign.category)+'">'+I18n.t(is_category(User.find(order_subset.subscribed_id).active_campaign.category))+'</span>',
            order_subset.updates,
            number_to_currency(order_subset.amount, unit: currency_signs(User.find(order_subset.subscribed_id).active_campaign.currency)),
            link_to(raw('<i class="ti-close"></i>'),unsub_user_payment_subscriptions_path(User.find(order_subset.subscribed_id).uid),method: :delete, data: { confirm: I18n.t('views.utilities.btn.are_you_sure_to')+I18n.t('views.utilities.btn.unsupport')+'?'})
          ]
        end
    end

    def order_subsets
        @order_subsets ||= fetch_order_subsets
    end

    def fetch_order_subsets
        order_subsets = OrderSubset.order("#{sort_column} #{sort_direction}").where(:order_id => @order.id, :deleted => nil, :transacted => nil)
        order_subsets = order_subsets.page(page).per_page(per_page)
        if params[:sSearch].present?
          order_subsets = order_subsets.where("subscribed_id like :search", search: "%#{params[:sSearch]}%")
        end
        order_subsets
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[updates amount]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end