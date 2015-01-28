class ThreadConnector < ActiveRecord::Base
  attr_accessible :discussion_id, :level_1_id, :level_2_id, :level_3_id, :level_4_id, :level_5_id
  belongs_to :discussion
  belongs_to :discussion_thread

  belongs_to :level_1, class_name: "DiscussionThread"
  belongs_to :level_2, class_name: "DiscussionThread"
  belongs_to :level_3, class_name: "DiscussionThread"
  belongs_to :level_4, class_name: "DiscussionThread"
  belongs_to :level_5, class_name: "DiscussionThread"      

end
