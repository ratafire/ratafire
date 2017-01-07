class Payment::OrdersMailer < ActionMailer::Base

    #----------------Utilities----------------
    layout 'mailer_order'
	include SendGrid
	default from: "noreply@ratafire.com"

	def send_confirmation(options = {})
		@order = Order.find(options[:order_id])
		@subscriber = User.find(@order.user.id)
		if @subscriber.locale
			I18n.locale = @subscriber.locale
		end	
		@order_subsets = @order.order_subsets
		subject = t('mailer.payment.subscription.order.subject')
		mail to: @subscriber.email, subject: subject
	end

	def recurring_payment_failed(options = {})
		@order = Order.find(options[:order_id])
		@subscriber = User.find(@order.user_id)
		if @subscriber.locale
			I18n.locale = @subscriber.locale
		end	
		subject = t('mailer.payment.subscription.receipt.payment_failed')
		mail to: @subscriber.email, subject: subject
	end

end