class P_P_Inspiration < ActiveRecord::Base
	attr_accessible :inspirer_id, :inspired_id, :inspirer_project_title, :inspired_project_title, :inspirer_project_username

  belongs_to :inspirer, class_name: "Project"
  belongs_to :inspired, class_name: "Project"

end