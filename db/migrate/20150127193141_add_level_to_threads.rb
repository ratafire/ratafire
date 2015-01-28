class AddLevelToThreads < ActiveRecord::Migration
  def change
  	add_column :discussion_threads, :level_1_id, :integer
  end
end
