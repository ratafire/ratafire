class Blacklist < ActiveRecord::Base
  attr_accessible :blacklister_id, :blacklisted_id, :message
  belongs_to :blacklister, class_name: "User"
  belongs_to :blacklisted, class_name: "User"
end
