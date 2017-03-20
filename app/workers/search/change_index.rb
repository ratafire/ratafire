class Search::ChangeIndex

	#Put due reward on queue
	@queue = :search

	def self.perform(content_type, content_id, order)
		#Create
		if order == 'create'
			case content_type
			when 'majorpost'
				if @majorpost = Majorpost.find(content_id)
					@majorpost.__elasticsearch__.index_document
				end
			when 'campaign'
				if @campaign = Campaign.find(content_id)
					@campaign.__elasticsearch__.index_document
				end
			when 'user'
				if @user = User.find(content_id)
					@user.__elasticsearch__.index_document
				end
			end
		end
		#Update
		if order == 'update'
			case content_type
			when 'majorpost'
				if @majorpost = Majorpost.find(content_id)
					@majorpost.__elasticsearch__.update_document
				end
			when 'campaign'
				if @campaign = Campaign.find(content_id)
					@campaign.__elasticsearch__.update_document
				end
			when 'user'
				if @user = User.find(content_id)
					@user.__elasticsearch__.update_document
				end
			end
		end
		#Delete
		if order == 'delete'
			case content_type
			when 'majorpost'
				if @majorpost = Majorpost.find(content_id)
					@majorpost.__elasticsearch__.delete_document
				end
			when 'campaign'
				if @campaign = Campaign.find(content_id)
					@campaign.__elasticsearch__.delete_document
				end
			when 'user'
				if @user = User.find(content_id)
					@user.__elasticsearch__.delete_document
				end
			end
		end
	end

end