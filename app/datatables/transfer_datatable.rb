class TransferDatatable

    delegate :params, :t, :link_to, :image_tag,:currency_signs,:number_to_currency, :raw, :is_category, :strftime, :transfer_color, :transfer_status, to: :@view

    def initialize(view)
    	@view = view
    	@user = User.find(params[:user_id])
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Transfer.where(user_id: @user.id),
      iTotalDisplayRecords: transfer.total_entries,
      aaData: data
    }
    end

private

    def data
        transfer.map do |transfer|
            if transfer.currency != nil
            [
                '<span class="bg-grey-100 pl-5 pr-5">'+transfer.uuid+"</span>",
                transfer.created_at.strftime('%Y/%m/%d'),
                number_to_currency(transfer.amount, unit: currency_signs(transfer.currency)),
                '<span class="label '+transfer_color(transfer.status)+'">'+I18n.t(transfer_status(transfer.status))+'</span>',
            ]
            else
            [
                '<span class="bg-grey-100 pl-5 pr-5">'+transfer.uuid+"</span>",
                transfer.created_at.strftime('%Y/%m/%d'),
                number_to_currency(transfer.amount),
                '<span class="label '+transfer_color(transfer.status)+'">'+I18n.t(transfer_status(transfer.status))+'</span>',
            ]
            end
        end
    end

    def transfer
        @transfer ||= fetch_transfer
    end

    def fetch_transfer
        transfer = Transfer.order("#{sort_column} #{sort_direction}").where(:user_id => @user.id)
        transfer = transfer.page(page).per_page(per_page)
        if params[:sSearch].present?
          transfer = transfer.where("amount like :search", search: "%#{params[:sSearch]}%")
        end
        transfer
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[uuid created_at amount status]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end