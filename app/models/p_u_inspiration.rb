class P_U_Inspiration < ActiveRecord::Base
attr_accessible :inspirer_id, :inspired_id, :user_username	
	
  belongs_to :inspirer, class_name: "User"
  belongs_to :inspired, class_name: "Project"
end