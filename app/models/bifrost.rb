class Bifrost < ActiveRecord::Base
  attr_accessible :connections_attributes, :project_id, :majorpost_id

  belongs_to :project

  #--- nested bridges ---
  has_many :connections, dependent: :destroy
  accepts_nested_attributes_for :connections, :allow_destroy => true

end
