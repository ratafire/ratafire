class Commentimage < ActiveRecord::Base
  attr_accessible :comment_id
  belongs_to :comment
end
