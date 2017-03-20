class Search::CreateIndex

	#Put due reward on queue
	@queue = :search

	def self.perform
		#Update Majorpost Search Index
		Majorpost.where(deleted: nil),__elasticsearch__.create_index!
		Majorpost.where(deleted: nil).__elasticsearch__.import
		#Campaign
		Campaign.where(status: 'Approved', deleted: nil).__elasticsearch__.create_index!
		Campaign.where(status: 'Approved', deleted: nil).__elasticsearch__.refresh_index!
		#User
		User.where(invitation_token: nil).__elasticsearch__.create_index!
		User.where(invitation_token: nil).__elasticsearch__.import
	end

end