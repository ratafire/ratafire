module ArchivesHelper

	def get_next_archive(archive)
		return archive.project.archives.where(Archive.arel_table[:majorpost_id].not_eq(nil)).where("id < ?", archive.id).order("id ASC").last
	end

	def get_prev_archive(archive)
		return archive.project.archives.where(Archive.arel_table[:majorpost_id].not_eq(nil)).where("id > ?", archive.id).order("id ASC").first
	end

end