class Email::NewslettersMailer < ActionMailer::Base

    #----------------Utilities----------------
	include SendGrid
	default from: "noreply@ratafire.com"

	def send_newsletter(options = {})
		@user = User.find(options[:user_id])
		@email = Email.find(options[:email_id])
		subject = @email.title
		mail to: @user.email, subject: subject
	end

end