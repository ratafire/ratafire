class Payment::OrdersMailer < ActionMailer::Base

    #----------------Utilities----------------
    layout 'mailer_order'
	include SendGrid
	default from: "noreply@ratafire.com"

	def send_confirmation(options = {})
		@order = Order.find(options[:order_id])
		@subscriber = User.find(@order.user.id)
		@order_subsets = @order.order_subsets
		subject = t('mailer.payment.subscription.order.subject')
		mail to: @subscriber.email, subject: subject
	end

end