class Ibifrost < ActiveRecord::Base
  attr_accessible :inviteds_attributes, :project_id

  belongs_to :project

  #--- nested bridges ---
  has_many :inviteds
  accepts_nested_attributes_for :inviteds, :allow_destroy => true

end
