class Campaign::CampaignDue

	#Put due campaign on queue
	@queue = :campaign

	def self.perform
		Campaign.where(deleted: nil, completed: nil, expired: nil, expiration_queued: nil).each do |campaign|
			#Check if the campaign is due
			if (campaign.due.to_i - Time.now.to_i) < 86400
				#Queue expiration
				Resque.enqueue_at(campaign.due, Campaign::ExpireCampaign, campaign.id)
				#Record expiration
				campaign.update(
					expiration_queued: true,
					expiration_queued_at: Time.now
				)
			end
		end
	end

end