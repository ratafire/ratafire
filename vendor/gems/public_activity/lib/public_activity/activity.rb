module PublicActivity
  # Main model, stores all information about what happened,
  # who caused it, when and anything else.
  class Activity < inherit_orm("Activity")
  	acts_as_taggable
  end
end