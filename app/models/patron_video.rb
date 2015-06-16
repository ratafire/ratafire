class PatronVideo < ActiveRecord::Base
	attr_accessible :admin_id, :status, :deleted, :review
  	default_scope order: 'patron_videos.created_at DESC'
  	has_one :video
  	belongs_to :user
end
