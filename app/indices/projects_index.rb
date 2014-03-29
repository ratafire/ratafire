ThinkingSphinx::Index.define :project, :with => :active_record do
	indexes :title
    indexes about
    indexes creator.fullname, as: :creator_fullname
end