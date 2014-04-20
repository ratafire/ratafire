class P_M_Inspiration < ActiveRecord::Base

attr_accessible :inspirer_id, :inspired_id, :majorpost_title, :majorpost_username

  belongs_to :inspirer, class_name: "Majorpost"
  belongs_to :inspired, class_name: "Project"
end