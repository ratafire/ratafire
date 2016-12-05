class FollowedDatatable

    delegate :params, :t, :link_to,:image_tag,:user_user_content_likes_path, :profile_url_path,:raw, to: :@view

    def initialize(view)
    	@view = view
    end

    def as_json(options = {})
	    {
	      sEcho: params[:sEcho].to_i,
	      #iTotalRecords: Tag.count,
	      iTotalDisplayRecords: likeds.total_entries,
	      aaData: data
	    }
	end

private

    def data
    	user = User.find(params[:user_id])
        likeds.map do |liked|
          [
          	link_to(image_tag(liked.profilephoto.image.url(:thumbnail40), class:"border-radius-3"), profile_url_path(liked.username)),
            link_to(liked.preferred_name, profile_url_path(liked.username)),
            liked.tagline,
            link_to(raw('<div class="btn btn-default">'+I18n.t('views.utilities.btn.unfollow')+'</div>'),user_user_content_likes_path(user.id, liked.id), remote: true,method: :delete)
          ]
        end
    end

    def likeds
        @likeds ||= fetch_likeds
    end

    def fetch_likeds
        likeds = User.find(params[:user_id]).likeds
        likeds = likeds.page(page).per_page(per_page)
        if params[:sSearch].present?
          likeds = likeds.where("name like :search", search: "%#{params[:sSearch]}%")
        end
        likeds
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