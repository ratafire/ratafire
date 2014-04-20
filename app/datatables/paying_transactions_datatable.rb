class PayingTransactionsDatatable
  delegate :params, :h, :link_to, :truncate,:transaction_details_path, :user_path, to: :@view

  def initialize(view)
    @view = view
    @user = User.find(params[:id])
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Transaction.where(:subscriber_id => @user.id).count,
      iTotalDisplayRecords: transactions.total_entries,
      aaData: data
    }
  end

private

  def data
    transactions.map do |transaction|
      [
        transaction.created_at.strftime("%Y-%m-%d"),
        link_to(truncate(subscribed_fullname(transaction.subscribed_id), :length => 30),user_path(transaction.subscriber_id), class:"no_ajaxify"),
        transaction.status,
        "$"+transaction.amount,
        amazon(transaction.amazon),
        ratafire(transaction.ratafire_fee),
        receive(transaction.receive),
        link_to("Details", transaction_details_path(@user.id, transaction.id), class:"no_ajaxify")
      ]
    end
  end

  def transactions
    @transactions ||= fetch_transactions
  end

  def fetch_transactions
    transactions = Transaction.where(:subscriber_id => @user.id).order("#{sort_column} #{sort_direction}")
    transactions = transactions.page(page).per_page(per_page)
    if params[:sSearch].present?
      transactions = transactions.where("amount like :search or created_at like :search or ratafire_fee like :search or receive like :search or amazon like :search or status like :search", search: "%#{params[:sSearch]}%")
    end
    transactions
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[created_at subscriber_id status amount amazon ratafire_fee receive]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end

  def subscribed_fullname(id)
    return User.find(id).fullname.to_s
  end

  def amazon(amount)
    if amount == nil then
      return "-"
    else
      return "-$"+amount.to_s
    end
  end

  def ratafire(amount)
    if amount == nil then
      return "-"
    else
      return "-$"+amount.to_s
    end
  end

  def receive(amount)
    if amount == nil then
      return "-"
    else
      return "$"+amount.to_s
    end
  end

end