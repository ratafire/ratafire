class Commentimage < ActiveRecord::Base
  attr_accessible :comment_id, :project_comment_id
  belongs_to :comment
  belongs_to :project_comment
end
