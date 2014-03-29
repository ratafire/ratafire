class Connection < ActiveRecord::Base
  attr_accessible :url, :bifrost_id, :internal
  belongs_to :bifrost
end
