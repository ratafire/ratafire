class ReceiverDatatable

    delegate :params, :t, :link_to, :image_tag,:currency_signs, :request_shipping_fee_user_payment_reward_receivers_path,:ship_reward_user_payment_reward_receivers_path,:raw,:profile_url_path, :is_category, to: :@view

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
            if @reward.shipping == 'no'
                case reward_receiver.status
                when 'paid'
                  [
                    link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    '<div class="label bg-green">'+I18n.t('views.creator_studio.rewards.paid')+'</div>',
                    I18n.t('views.creator_studio.rewards.waiting')
                  ]
                when 'ready_to_download'
                  [
                    link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    '<div class="label bg-green">'+I18n.t('views.creator_studio.rewards.paid')+'</div>',
                    I18n.t('views.creator_studio.rewards.waiting')
                  ]
                end
            else
                case reward_receiver.status
                when 'waiting_for_payment'
                  [
                    link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    '<div class="label bg-pink">'+I18n.t('views.creator_studio.rewards.reserved')+'</div>',
                    I18n.t('views.creator_studio.rewards.waiting')      
                  ]
                when 'shipping_fee_request_sent'
                  [
                    link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    '<div class="label bg-orange">'+I18n.t('views.creator_studio.rewards.waiting_for_shipping_fee')+'</div>',
                    I18n.t('views.creator_studio.rewards.waiting')      
                  ]
                when 'paid'
                  [
                    link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    '<div class="label bg-blue">'+I18n.t('views.creator_studio.rewards.paid')+'</div>',
                    link_to(raw('<div class="btn btn-blue">'+I18n.t('views.creator_studio.rewards.request_shipping_fee')+' '+currency_signs(@reward.currency)+reward_receiver.amount.to_i.to_s+'</div>'), request_shipping_fee_user_payment_reward_receivers_path(reward_receiver.user_id,reward_receiver.id))
                  ]
                when 'ready_to_ship'
                  [
                    link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                    '<div class="label bg-purple">'+I18n.t('views.creator_studio.rewards.ready_to_ship')+'</div>',
                    link_to(raw('<div class="btn bg-green">'+I18n.t('views.creator_studio.rewards.ship')+' '+currency_signs(@reward.currency)+reward_receiver.amount.to_i.to_s+'</div>'), ship_reward_user_payment_reward_receivers_path(reward_receiver.user_id,reward_receiver.id))
                  ]
                when 'shipped'
                  if reward_receiver.shipping_company
                    if reward_receiver.tracking_number
                      [
                        link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                        link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                        '<div class="label bg-green">'+I18n.t('views.creator_studio.rewards.shipped')+'</div>',
                        reward_receiver.shipping_company+' '+reward_receiver.tracking_number
                      ]
                    else
                      [
                        link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                        link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                        '<div class="label bg-green">'+I18n.t('views.creator_studio.rewards.shipped')+'</div>',
                        reward_receiver.shipping_company
                      ]
                    end
                  else
                      [
                        link_to(image_tag(User.find(reward_receiver.user_id).profilephoto.image.url(:thumbnail40)), profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                        link_to(User.find(reward_receiver.user_id).preferred_name, profile_url_path(User.find(reward_receiver.user_id).username),target:"_blank"),
                        '<div class="label bg-green">'+I18n.t('views.creator_studio.rewards.shipped')+'</div>',
                        ''
                      ]
                  end
                end
            end
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
        columns = %w[user_id user_id status status]
        columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
        params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

end