class AddLevelIdsToDiscussionThreads < ActiveRecord::Migration
  def change
  	add_column :discussion_threads, :level_2_id, :integer
  	add_column :discussion_threads, :level_3_id, :integer
  	add_column :discussion_threads, :level_4_id, :integer
  end
end
