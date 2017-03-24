class AchievementsDatatable

    delegate :params, :t, :link_to,:image_tag, :edit_admin_achievements_path,:I18n, to: :@view

    def initialize(view)
    	@view = view
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Achievement.count,
      iTotalDisplayRecords: achievements.total_entries,
      aaData: data
    }
    end

private

    def data
        achievements.map do |achievement|
            if I18n.locale == :zh
                [
                    achievement.id,
                    image_tag(achievement.image, class:"border-radius-3", style:"width:40px;"),
                    achievement.name_zh,
                    achievement.description_zh,
                    achievement.category,
                    achievement.sub_category,
                    achievement.achievement_points,
                    achievement.hidden,
                    link_to(t('views.utilities.editor.edit'), edit_admin_achievements_path(achievement.id), remote: true)
                  ]
            else
                [
                    achievement.id,
                    image_tag(achievement.image, class:"border-radius-3", style:"width:40px;"),
                    achievement.name,
                    achievement.description,
                    achievement.category,
                    achievement.sub_category,
                    achievement.achievement_points,
                    achievement.hidden,
                    link_to(t('views.utilities.editor.edit'), edit_admin_achievements_path(achievement.id), remote: true)
                  ]
            end
        end
    end

    def achievements
        @achievements ||= fetch_achievements
    end

    def fetch_achievements
        achievements = Achievement.order("#{sort_column} #{sort_direction}")
        achievements = achievements.page(page).per_page(per_page)
        if params[:sSearch].present?
          achievements = achievements.where("name like :search", search: "%#{params[:sSearch]}%")
        end
        achievements
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[id name name description category sub_category achievement_points]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end