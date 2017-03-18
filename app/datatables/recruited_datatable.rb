class RecruitedDatatable

    delegate :params, :t, :link_to,:image_tag,:unsub_user_payment_subscriptions_path, :profile_url_path,:raw, to: :@view

    def initialize(view)
    	@view = view
    end

    def as_json(options = {})
	    {
	      sEcho: params[:sEcho].to_i,
	      #iTotalRecords: Tag.count,
	      iTotalDisplayRecords: recruited.total_entries,
	      aaData: data
	    }
	end

private

    def data
        user = User.find(params[:user_id])
        recruited.map do |recruited|
        if recruited.invitation_token
            [
                recruited.email,
                '<div class="label bg-blue">'+I18n.t('views.creator_studio.community.recruit_a_friend.invited')+'</div>'
            ]
        else
            [
                recruited.email,
                '<div class="label bg-green">'+I18n.t('views.creator_studio.community.recruit_a_friend.recruited')+'</div>'
            ]
        end
        end
    end

    def recruited
        @recruited ||= fetch_recruited
    end

    def fetch_recruited
        recruited = User.where(invited_by_id: params[:user_id])
        recruited = recruited.page(page).per_page(per_page)
        if params[:sSearch].present?
          recruited = recruited.where("name like :search", search: "%#{params[:sSearch]}%")
        end
        recruited
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