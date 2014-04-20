class Postimage < ActiveRecord::Base
  attr_accessible :majorpost_id
  belongs_to :majorpost
end
