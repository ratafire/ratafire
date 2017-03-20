class Search::CreateIndex

	#Put due reward on queue
	@queue = :search

	def self.perform
		#Update Majorpost Search Index
		Majorpost.where(deleted: nil,deleted_at: nil).__elasticsearch__.create_index!
		Majorpost.where(deleted: nil, deleted_at: nil).__elasticsearch__.import
		Majorpost.where(deleted: nil, deleted_at: nil).__elasticsearch__.refresh_index!
		#Campaign
		Campaign.where(status: 'Approved', deleted: nil).__elasticsearch__.create_index!
		Campaign.where(status: 'Approved', deleted: nil).import
		Campaign.where(status: 'Approved', deleted: nil).__elasticsearch__.refresh_index!
		#User
		User.where(invitation_token: nil).__elasticsearch__.create_index!
		User.where(invitation_token: nil).__elasticsearch__.import
		User.where(invitation_token: nil).__elasticsearch__.refresh_index!
	end

end