class SecretMailer < ActionMailer::Base
	include SendGrid
	default from: "noreply@ratafire.com"
	include Resque::Mailer

	def secret_redeemed(secret_id)
		@secret = Secret.find(secret_id)
		@user = User.find(@secret.user_id)
		subject = "Secret Redeemed"
		mail to: @user.email, subject: subject
	end

	def video_secret_admin_alert(secret_id)
		@secret = Secret.find(secret_id)
		@user = User.find(@secret.user_id)
		subject = @user.fullname + " Redeemed a Video Secret"
		mail to: ENV["ADMIN_EMAIL"], subject: subject
	end

end