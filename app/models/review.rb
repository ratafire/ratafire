class Review < ActiveRecord::Base
  attr_accessible :title, :content, :user_id, :project_id, :status, :discussion_id, :subscription_application_id
  belongs_to :project
  belongs_to :user
  belongs_to :discussion
  belongs_to :subscription_application


end
