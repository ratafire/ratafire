class CreateAssignedDiscussions < ActiveRecord::Migration
  def change
    create_table :assigned_discussions do |t|
      t.integer :discussion_id
      t.integer :user_id
      t.timestamps
    end
  end
end
