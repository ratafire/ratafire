class Payment::ShippingOrdersMailer < ActionMailer::Base

    #----------------Utilities----------------
    layout 'mailer_shipping_order'
	include SendGrid
	default from: "noreply@ratafire.com"

	def send_confirmation(options = {})
		@shipping_order = ShippingOrder.find(options[:shipping_order_id])
		@user = User.find(@shipping_order.user_id)
		if @user.locale
			I18n.locale = @user.locale
		end
		subject = t('mailer.payment.shipping_order.subject')+@shipping_order.reward.title
		mail to: @user.email, subject: subject
	end

	def ready_to_download(options = {})
		@reward_receiver = RewardReceiver.find(options[:reward_receiver_id])
		@user = User.find(@reward_receiver.user_id)
		if @user.locale
			I18n.locale = @user.locale
		end		
		subject = @reward_receiver.reward.title+t('mailer.payment.shipping_order.ready_for_download')
		mail to: @user.email, subject: subject
	end

end