class AssignedDiscussion < ActiveRecord::Base
  attr_accessible :user_id, :discussion_id
  belongs_to :user
  belongs_to :discussion
end
