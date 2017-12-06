class ReceiptDatatable
    delegate :params, :t, :link_to, :image_tag, :category_color,:currency_signs, :unsub_user_payment_subscriptions_path,:raw,:profile_url_path, :is_category, to: :@view

    def initialize(view)
    	@view = view
    	@user = User.find(params[:user_id])
    	@transaction = Transaction.find(params[:transaction_id])
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: TransactionSubset.where(:transaction_id => @transaction.id, :deleted => nil).count,
      iTotalDisplayRecords: transaction_subsets.total_entries,
      aaData: data
    }
    end

private

    def data
        transaction_subsets.map do |transaction_subset|
          [
            link_to(image_tag(User.find(transaction_subset.subscribed_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(transaction_subset.subscribed_id).username),target:"_blank"),
            link_to(User.find(transaction_subset.subscribed_id).preferred_name, profile_url_path(User.find(transaction_subset.subscribed_id).username),target:"_blank"),
            transaction_subset.updates.to_s,
            transaction_subset.description,
            currency_signs(transaction_subset.currency)+transaction_subset.amount.to_s,
          ]
        end
    end

    def transaction_subsets
        @transaction_subsets ||= fetch_transaction_subsets
    end

    def fetch_transaction_subsets
        transaction_subsets = TransactionSubset.order("#{sort_column} #{sort_direction}").where(:transaction_id => @transaction.id, :deleted => nil)
        transaction_subsets = transaction_subsets.page(page).per_page(per_page)
        if params[:sSearch].present?
          transaction_subsets = transaction_subsets.where("subscribed_id like :search", search: "%#{params[:sSearch]}%")
        end
        transaction_subsets
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[amount]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end