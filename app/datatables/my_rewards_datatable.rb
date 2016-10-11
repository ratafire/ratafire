class MyRewardsDatatable

    delegate :params, :t, :link_to, :truncate, :image_tag, :currency_signs,:raw,:confirm_shipping_payment_user_studio_rewards_path, :profile_url_path, :is_category, to: :@view

    def initialize(view)
    	@view = view
    	@user = User.find(params[:user_id])
    end

    def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: RewardReceiver.where(user_id: @user.id, deleted: nil),
      iTotalDisplayRecords: reward_receiver.total_entries,
      aaData: data
    }
    end

private

    def data
        reward_receiver.map do |reward_receiver|
        	@reward = Reward.find(reward_receiver.reward_id)
            if @reward.shipping == 'no'
                case reward_receiver.status
                when 'paid'
                    if @reward.image.present?
                      [
                        image_tag(@reward.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-pink">'+I18n.t('views.creator_studio.rewards.reserved')+'</div>',
                        I18n.t('views.creator_studio.rewards.waiting')                           
                      ]
                    else
                      [
                        image_tag(@reward.campaign.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-pink">'+I18n.t('views.creator_studio.rewards.reserved')+'</div>',
                        I18n.t('views.creator_studio.rewards.waiting')
                      ]
                    end
                when 'ready_to_download'
                    if @reward.image.present?
                      [
                        image_tag(@reward.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-green">'+I18n.t('views.creator_studio.rewards.completed')+'</div>',
                        link_to(raw('<div class="btn bg-green">'+I18n.t('views.utilities.menu.download')+'</div>'),@reward.reward_uploads.package.url)
                      ]
                    else
                      [
                        image_tag(@reward.campaign.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-green">'+I18n.t('views.creator_studio.rewards.completed')+'</div>',
                        link_to(raw('<div class="btn bg-green">'+I18n.t('views.utilities.menu.download')+'</div>'),@reward.reward_uploads.package.url)
                      ]
                    end
                end
            else
                case reward_receiver.status
                when 'waiting_for_payment'
                    if @reward.image.present?
                      [
                        image_tag(@reward.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-pink">'+I18n.t('views.creator_studio.rewards.reserved')+'</div>',
                        I18n.t('views.creator_studio.rewards.waiting')                      
                      ]
                    else
                      [
                        image_tag(@reward.campaign.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-pink">'+I18n.t('views.creator_studio.rewards.reserved')+'</div>',
                        I18n.t('views.creator_studio.rewards.waiting')                      
                      ]
                    end
                when 'paid'
                    if @reward.image.present?
                      [
                        image_tag(@reward.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-blue">'+I18n.t('views.creator_studio.rewards.paid')+'</div>',
                        I18n.t('views.creator_studio.rewards.waiting')                      
                      ]
                    else
                      [
                        image_tag(@reward.campaign.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-blue">'+I18n.t('views.creator_studio.rewards.paid')+'</div>',
                        I18n.t('views.creator_studio.rewards.waiting')                      
                      ]
                    end
                when 'shipping_fee_request_sent'
                    if @reward.image.present?
                      [
                        image_tag(@reward.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-orange">'+I18n.t('views.creator_studio.rewards.waiting_for_shipping_fee')+'</div>',
                        link_to(raw('<div class="btn bg-green">'+I18n.t('mailer.payment.shipping_order.pay_shipping_fee')+' '+currency_signs(@reward.currency)+reward_receiver.amount.to_s+'</div>'),confirm_shipping_payment_user_studio_rewards_path(reward_receiver.user_id,reward_receiver.shipping_order.id))
                      ]
                    else
                      [
                        image_tag(@reward.campaign.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-orange">'+I18n.t('views.creator_studio.rewards.waiting_for_shipping_fee')+'</div>',
                        link_to(raw('<div class="btn bg-green">'+I18n.t('mailer.payment.shipping_order.pay_shipping_fee')+' '+currency_signs(@reward.currency)+reward_receiver.amount.to_s+'</div>'),confirm_shipping_payment_user_studio_rewards_path(reward_receiver.user_id,reward_receiver.shipping_order.id))
                      ]
                    end
                when 'ready_to_ship'
                    if @reward.image.present?
                      [
                        image_tag(@reward.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-purple">'+I18n.t('views.creator_studio.rewards.ready_to_ship')+'</div>',
                        I18n.t('views.creator_studio.rewards.waiting')
                      ]
                    else
                      [
                        image_tag(@reward.campaign.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-purple">'+I18n.t('views.creator_studio.rewards.ready_to_ship')+'</div>',
                        I18n.t('views.creator_studio.rewards.waiting')
                      ]
                    end
                when 'shipped'
                    if @reward.image.present?
                      [
                        image_tag(@reward.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
                        '<div class="label bg-green">'+I18n.t('views.creator_studio.rewards.shipped')+'</div>',
                        ''
                      ]
                    else
                      [
                        image_tag(@reward.campaign.image.url(:thumbnail40), class:"border-radius-3"),
                        truncate(@reward.title, length: 50),
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
        reward_receiver = RewardReceiver.order("#{sort_column} #{sort_direction}").where(:user_id => @user.id, :deleted => nil)
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