class PatronVideoReviewMailer < ActionMailer::Base
  include SendGrid
  default from: "noreply@ratafire.com"

  #A Receipt Email for Discussion Review
  def patron_video_review(patron_video_id)
  	@patron_video = PatronVideo.find(patron_video_id)
    @user = @patron_video.user
  	if @patron_video.status == "Approved" then
  		subject = "Your introduction video update is approved"
      @content = "Congratulations! Your introduction video update is approved."
  	else
  		subject = "Your introduction video update is not approved"
      @content = "Sorry, your introduction video update is not approved."
  	end
    mail to: @user.email, subject: subject
  end

end