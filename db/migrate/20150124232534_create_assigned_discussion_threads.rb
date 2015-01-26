class CreateAssignedDiscussionThreads < ActiveRecord::Migration
  def change
    create_table :assigned_discussion_threads do |t|
      t.integer :assigned_discussion_id
      t.integer :user_id
      t.timestamps
    end
  end
end
