class Invited < ActiveRecord::Base
  attr_accessible :project_id, :bifrost_id, :user_id, :username ,:accept
  belongs_to :ibifrost
  belongs_to :project
  belongs_to :user
end
