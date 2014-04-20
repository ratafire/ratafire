module PublicActivity
  class Activity < inherit_orm("Activity")
  	acts_as_taggable
  	acts_as_taggable_on :liker
  	default_scope where(:deleted => false)
  	scope :active, where(:deleted => false)
  end
end