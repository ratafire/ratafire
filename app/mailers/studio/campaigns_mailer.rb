class Studio::CampaignsMailer < ActionMailer::Base

    #----------------Utilities----------------
    layout 'mailer_notification_mini'
	include SendGrid
	default from: "noreply@ratafire.com"

	#Let the user know the result of the pending campaign
	def review(campaign_id)
		if @campaign = Campaign.find(campaign_id)
			@user = @campaign.user
			if @campaign.user.locale
				I18n.locale = @campaign.user.locale
			end
			if @campaign.status == "Approved"
				@subject = t('mailer.studio.campaigns.review.you_are_now_a_ratafire') + t('mailer.studio.campaigns.review.creator')
				@line1 = t('mailer.studio.campaigns.review.welcome') + @campaign.user.preferred_name + "!"
				@line2 = t('mailer.studio.campaigns.review.your_project') + @campaign.title + t('mailer.studio.campaigns.review.is_now_live')
				@link = t('mailer.layout.view_on_ratafire')
			else
				@subject = t('mailer.studio.campaigns.review.your_application_is_declined')
				@line1 = t('mailer.studio.campaigns.review.sorry') + @campaign.user.preferred_name
				@line2 = t('mailer.studio.campaigns.review.your_project') + @campaign.title + t('mailer.studio.campaigns.review.is_not_approved')
				@link = t('mailer.layout.back_to_ratafire')
			end
			mail to: @campaign.user.email, subject: @subject
		end
	end
end