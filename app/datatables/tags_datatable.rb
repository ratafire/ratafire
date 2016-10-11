class TagsDatatable

    delegate :params, :t, :link_to,:image_tag, :edit_admin_tags_path,:number_to_human, to: :@view

    def initialize(view)
    	@view = view
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Tag.count,
      iTotalDisplayRecords: tags.total_entries,
      aaData: data
    }
    end

private

    def data
        tags.map do |tag|
          [
            tag.id,
            image_tag(tag.tag_image.image.url(:thumbnail40), class:"border-radius-3", style:"width:40px;"),
            tag.name,
            tag.description,
            number_to_human(tag.taggings.where(:taggable_type => "Majorpost").count+tag.taggings.where(:taggable_type => "Campaign").count, :format => '%n%u', :units => { :thousand => 'k' }),
            number_to_human(tag.taggings.where(:taggable_type => "User").count, :format => '%n%u', :units => { :thousand => 'k' }),
            link_to(t('views.utilities.editor.edit'), edit_admin_tags_path(tag.id), remote: true)
          ]
        end
    end

    def tags
        @tags ||= fetch_tags
    end

    def fetch_tags
        tags = Tag.order("#{sort_column} #{sort_direction}")
        tags = tags.page(page).per_page(per_page)
        if params[:sSearch].present?
          tags = tags.where("name like :search", search: "%#{params[:sSearch]}%")
        end
        tags
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[id name name description taggings_count taggings_count name]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end