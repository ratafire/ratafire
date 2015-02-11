class Review < ActiveRecord::Base
  attr_accessible :title, :content, :user_id, :project_id, :status, :discussion_id
  belongs_to :project
  belongs_to :user
  belongs_to :discussion


end
