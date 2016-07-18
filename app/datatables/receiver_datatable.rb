class ReceiverDatatable

    delegate :params, :t, :link_to, :image_tag, :category_color,:currency_signs, :unsub_user_payment_subscriptions_path,:raw,:profile_url_path, :is_category, to: :@view

    def initialize(view)
    	@view = view
    	@user = User.find(params[:user_id])
    	@reward = Reward.find(params[:reward_id])
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: RewardReceiver.where(reward_id: @reward.id),
      iTotalDisplayRecords: reward_receiver.total_entries,
      aaData: data
    }
    end

private

    def data
        reward_receiver.map do |reward_receiver|
          [
            link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
            link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
            reward_receiver.shipping_paid,
            reward_receiver.uuid
          ]
        end
    end

    def reward_receiver
        @reward_receiver ||= fetch_reward_receiver
    end

    def fetch_reward_receiver
        reward_receiver = RewardReceiver.order("#{sort_column} #{sort_direction}").where(:reward_id => @reward.id)
        reward_receiver = reward_receiver.page(page).per_page(per_page)
        if params[:sSearch].present?
          reward_receiver = reward_receiver.where("subscribed_id like :search", search: "%#{params[:sSearch]}%")
        end
        reward_receiver
    end

    def page
        params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
        params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
        columns = %w[shipping_paid paid status]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end