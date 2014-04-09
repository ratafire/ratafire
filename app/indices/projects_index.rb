ThinkingSphinx::Index.define :project, :with => :active_record do
	indexes :title
    indexes about
    indexes creator.fullname, as: :creator_fullname
    indexes published
    indexes deleted
    indexes complete
    indexes realm
    indexes featured
    indexes commented_at
    indexes tagline    
end