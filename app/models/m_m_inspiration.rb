class M_M_Inspiration < ActiveRecord::Base

	attr_accessible :inspirer_id, :inspired_id, :inspirer_majorpost_title, :inspired_majorpost_title, :inspirer_majorpost_username

  belongs_to :inspirer, class_name: "Majorpost"
  belongs_to :inspired, class_name: "Majorpost"

end