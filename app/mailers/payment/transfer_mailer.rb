class Payment::TransferMailer < ActionMailer::Base

    #----------------Utilities----------------
    layout 'mailer_notification_mini'
	include SendGrid
	default from: "noreply@ratafire.com"

	def transfer_sent(options = {})
		@transfer = Transfer.find(options[:transfer_id])
		@line1 = t('mailer.payment.subscription.transfer.line1')
		@line2 = t('mailer.payment.subscription.transfer.line2')
		@link = t('mailer.layout.view_on_ratafire')
		@user = @transfer.user
		subject = t('mailer.payment.subscription.transfer.transfer_sent')
		mail to: @transfer.user.email, subject: subject
	end

end