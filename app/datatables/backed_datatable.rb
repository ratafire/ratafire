class BackedDatatable

    delegate :params, :t, :link_to,:image_tag,:unsub_user_payment_subscriptions_path, :profile_url_path,:raw, to: :@view

    def initialize(view)
    	@view = view
    end

    def as_json(options = {})
	    {
	      sEcho: params[:sEcho].to_i,
	      #iTotalRecords: Tag.count,
	      iTotalDisplayRecords: subscribeds.total_entries,
	      aaData: data
	    }
	end

private

    def data
        user = User.find(params[:user_id])
        subscribeds.map do |subscribed|
        if subscribed.subscribed_by?(user)
            [
                link_to(image_tag(subscribed.profilephoto.image.url(:thumbnail40), class:"border-radius-3"), profile_url_path(subscribed.username)),
                link_to(subscribed.preferred_name, profile_url_path(subscribed.username)),
                "<img class='mr-5' src='/assets/icon/fruity/hazel_nut_thumbnail24.png' style='height:24px;'><span class='ml-5 mr-5'>x</span>"+SubscriptionRecord.find_by_subscribed_id_and_subscriber_id(subscribed.id, user.id).accumulated_total.to_i.to_s,
                link_to(raw('<div class="btn btn-default">'+I18n.t('views.utilities.btn.unsupport')+'</div>'),unsub_user_payment_subscriptions_path(subscribed.id), method: :delete, data: { confirm: t('views.utilities.btn.are_you_sure_to')+t('views.utilities.btn.unsupport')+'?'})
            ]
        else
            [
                link_to(image_tag(subscribed.profilephoto.image.url(:thumbnail40), class:"border-radius-3"), profile_url_path(subscribed.username)),
                link_to(subscribed.preferred_name, profile_url_path(subscribed.username)),
                "<img class='mr-5' src='/assets/icon/fruity/hazel_nut_thumbnail24.png' style='height:24px;'><span class='ml-5 mr-5'>x</span>"+SubscriptionRecord.find_by_subscribed_id_and_subscriber_id(subscribed.id, user.id).accumulated_total.to_i.to_s,
                ""
            ]
        end
        end
    end

    def subscribeds
        @subscribeds ||= fetch_subscribeds
    end

    def fetch_subscribeds
        subscribeds = User.find(params[:user_id]).record_subscribed
        subscribeds = subscribeds.page(page).per_page(per_page)
        if params[:sSearch].present?
          subscribeds = subscribeds.where("name like :search", search: "%#{params[:sSearch]}%")
        end
        subscribeds
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[id preferred_name tagline]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end