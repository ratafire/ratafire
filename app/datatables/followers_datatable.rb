class FollowersDatatable

    delegate :params, :t, :link_to,:image_tag,:remove_liker_user_content_likes_path, :profile_url_path,:raw, to: :@view

    def initialize(view)
    	@view = view
    end

    def as_json(options = {})
	    {
	      sEcho: params[:sEcho].to_i,
	      #iTotalRecords: Tag.count,
	      iTotalDisplayRecords: likers.total_entries,
	      aaData: data
	    }
	end

private

    def data
    	user = User.find(params[:user_id])
        likers.map do |liker|
          [
          	link_to(image_tag(liker.profilephoto.image.url(:thumbnail40), class:"border-radius-3"), profile_url_path(liker.username)),
            link_to(liker.preferred_name, profile_url_path(liker.username)),
            liker.tagline,
            link_to(raw('<div class="btn btn-default">'+I18n.t('views.utilities.btn.unfollow')+'</div>'),remove_liker_user_content_likes_path(user.id, liker.id), method: :delete)
          ]
        end
    end

    def likers
        @likers ||= fetch_likers
    end

    def fetch_likers
        likers = User.find(params[:user_id]).likers
        likers = likers.page(page).per_page(per_page)
        if params[:sSearch].present?
          likers = likers.where("name like :search", search: "%#{params[:sSearch]}%")
        end
        likers
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