class HistoricalQuotesDatatable
    delegate :params, :t, :link_to, :edit_admin_historical_quotes_path, to: :@view

    def initialize(view)
    @view = view
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: HistoricalQuote.count,
      iTotalDisplayRecords: historical_quotes.total_entries,
      aaData: data
    }
    end

private

    def data
        historical_quotes.map do |historical_quote|
          [
            historical_quote.id,
            historical_quote.quote,
            historical_quote.author,
            historical_quote.source,
            historical_quote.chapter,
            link_to(t('views.utilities.editor.edit'), edit_admin_historical_quotes_path(historical_quote.id), remote: true)
          ]
        end
    end

    def historical_quotes
        @historical_quotes ||= fetch_historical_quotes
    end

    def fetch_historical_quotes
        historical_quotes = HistoricalQuote.order("#{sort_column} #{sort_direction}")
        historical_quotes = historical_quotes.page(page).per_page(per_page)
        if params[:sSearch].present?
          historical_quotes = historical_quotes.where("quote like :search or author like :search or source like :search or chapter like :search", search: "%#{params[:sSearch]}%")
        end
        historical_quotes
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[id quote author source chapter]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end
end