class M_P_Inspiration < ActiveRecord::Base

attr_accessible :inspirer_id, :inspired_id, :project_title, :project_creator_username

  belongs_to :inspirer, class_name: "Project"
  belongs_to :inspired, class_name: "Majorpost"
end