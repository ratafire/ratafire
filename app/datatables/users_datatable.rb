class UsersDatatable

  delegate :params, :h, :link_to, :time_ago_in_words, :profile_url_path, :truncate,:image_tag, to: :@view

	def initialize(view)
		@view = view
	end

  def as_json(options = {})
	{
	  sEcho: params[:sEcho].to_i,
	  iTotalRecords: User.count,
	  iTotalDisplayRecords: users.total_entries,
	  aaData: data
	}
  end

private

  def data
	users.map do |user|
	  [
	  	user.id,
	  	link_to(image_tag(user.profilephoto.image.url(:thumbnail40)), profile_url_path(user.username),target:"_blank"),
		link_to(user.fullname,profile_url_path(user.username),target:"_blank"),
		user.email,
		user.tagline,
		user.majorpost.count,
		user.active_campaign.any?
	  ]
	end
  end

  def users
	@users ||= fetch_users
  end

  def fetch_users
	users = User.order("#{sort_column} #{sort_direction}")
	users = users.page(page).per_page(per_page)
	if params[:sSearch].present?
		users = users.where("fullname like :search or username like :search or email like :search or website like :search", search: "%#{params[:sSearch]}%")
	end
	users
  end

  def page
	params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
	params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
	columns = %w[id username fullname email tagline creator creator]
	columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
	params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end


end