class ProjectReviewMailer < ActionMailer::Base
  include SendGrid
  default from: "noreply@ratafire.com"

  #A Receipt Email for Discussion Review
  def project_review(review_id,message_title,stars,reviewer_id)
    @review = ProjectComment.find(review_id)
    @project = Project.find(@review.project_id)
    @user = User.find(reviewer_id)
    subject = "Your Project has a new Review"
    mail to: @project.creator.email, subject: subject
  end

end