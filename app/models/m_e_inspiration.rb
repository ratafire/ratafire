class M_E_Inspiration < ActiveRecord::Base
  attr_accessible :inspired_id, :url, :title
  belongs_to :inspired, class_name: "Majorpost"

end