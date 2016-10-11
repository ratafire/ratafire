class Campaign::ExpireCampaign

	#Expire due campaign
	@queue = :campaign

	def self.perform(campaign_id)
		if @campaign = Campaign.find(campaign_id)
			#Expire this campaign
			@campaign.update(
				expired: true,
				expired_at: Time.now
			)
			#Send notification
			Notification.create(
				user_id: @campaign.user_id,
				trackable_id: @campaign.id,
				trackable_type: "Campaign",
				notification_type: "campaign_due"
			)
		end
	end

end