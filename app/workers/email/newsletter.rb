class Email::Newsletter

	#Put due campaign on queue
	@queue = :email

	def self.perform(email_id)
		if email = Email.find(email_id)
			if email.status = "submitted"
				User.not_opted_out.each do |user|
					Email::NewslettersMailer.send_newsletter(email_id: email_id, user_id: user.id).deliver_now
					email.update(receiver_count: email.receiver_count + 1)
				end
				email.update(status: "sent")
			end
		end
	end

end