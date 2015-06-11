class SubscriptionApplicationReviewMailer < ActionMailer::Base
  include SendGrid
  default from: "noreply@ratafire.com"

  #A Receipt Email for Discussion Review
  def subscription_application_review(subscription_application_id,review_id,message_content,message_title)
  	@subscription_application = SubscriptionApplication.find(subscription_application_id)
    @user = @subscription_application.user
  	@review = Review.find(review_id)
  	if @subscription_application.status == "Approved" then
  		@subscription_application_status = "You can now accept patrons. Congratulations!"
  	else
  		@subscription_application_status = "Your application is disapproved."
  	end
  	@review_content = @review.content
    subject = message_title
    mail to: @subscription_application.user.email, subject: subject
  end

  #A Receipt Email for Failed 3 Supporters Task
  def fail_supporters(id)
    @user = User.find(id)
    subject = "Your Patronage Setup is Deactivated"
    mail to: @user.email, subject: subject
  end

  #A Receipt Email for Successful 3 Supporters Task
  def success_supporters(id)
    @user = User.find(id)
    subject = "You have found your first Patron!"
    mail to: @user.email, subject: subject    
  end

end