class Payment::SubscriptionsMailer < ActionMailer::Base

    #----------------Utilities----------------
    layout 'mailer_receipt'
	include SendGrid
	default from: "noreply@ratafire.com"

	def transaction_confirmation(options = {})
		@transaction = Transaction.find(options[:transaction_id])
		@subscriber = User.find(@transaction.subscriber_id)
		subject = t('mailer.payment.subscription.receipt.ratafire_receipt')
		#Create receipt items for transaction form
		@transaction_form = Array.new
		if options[:order_id]
		else
			@transaction_subsets = @transaction.transaction_subsets
		end
		mail to: @subscriber.email, subject: subject
	end

end