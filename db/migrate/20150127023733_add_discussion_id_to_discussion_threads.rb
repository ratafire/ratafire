class AddDiscussionIdToDiscussionThreads < ActiveRecord::Migration
  def change
  	add_column :discussion_threads, :discussion_id, :integer
  end
end
