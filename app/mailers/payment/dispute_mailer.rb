class Payment::TransferMailer < ActionMailer::Base

    #----------------Utilities----------------
    layout 'mailer_notification_mini'
	include SendGrid
	default from: "noreply@ratafire.com"

	def create_dispute_subscribed(options = {})
		@dispute = Dispute.find(options[:dispute_id])
		if @dispute.stripe_balance_transaction_id != nil
			@line1 = t('mailer.payment.subscription.dispute.line1_1')
			@line2 = t('mailer.payment.subscription.dispute.line2_1')
			@line3 = t('mailer.payment.subscription.dispute.line3_1')
			@subject = number_to_currency(@dispute.amount, unit: @dispute.currency)+' '+t('mailer.payment.subscription.dispute.line1_1')+' '+@dispute.subscriber.preferred_name+' '+t('mailer.payment.subscription.dispute.line2_1')
		else
			@line1 = t('mailer.payment.subscription.dispute.line1_1')
			@line2 = t('mailer.payment.subscription.dispute.line2_2')
			@line3 = t('mailer.payment.subscription.dispute.line3_2')
			@subject = number_to_currency(@dispute.amount, unit: @dispute.currency)+' '+t('mailer.payment.subscription.dispute.line1_1')+' '+@dispute.subscriber.preferred_name+' '+t('mailer.payment.subscription.dispute.line2_2')
		end
		@link = t('mailer.layout.view_on_ratafire')
		@user = @dispute.subscribed
		mail to: @dispute.subscribed.email, subject: @subject
	end

end