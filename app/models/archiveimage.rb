class Archiveimage < ActiveRecord::Base
	attr_accessible :archive_id
	belongs_to :archive
end
