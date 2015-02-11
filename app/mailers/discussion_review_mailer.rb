class DiscussionReviewMailer < ActionMailer::Base
  include SendGrid
  default from: "noreply@ratafire.com"

  #A Receipt Email for Discussion Review
  def discussion_review(discussion_id,review_id,message_content,message_title)
  	@discussion = Discussion.find(discussion_id)
  	@review = Review.find(review_id)
  	if @discussion.review_status == "Approved" then
  		@discussion_status = "Your discussion is approved. Congratulations!!"
  	else
  		@discussion_status = "Your discussion is approved."
  	end
  	@review_content = @review.content
  	@discussion_id = @discussion.id.to_s
  	@discussion_title = @discussion.title
  	@extra_message = "You can edit your discussion to apply again or delete it. Thank you."
    subject = message_title
    mail to: @discussion.creator.email, subject: subject
  end

end