class CreateThreadConnectors < ActiveRecord::Migration
  def change
    create_table :thread_connectors do |t|
      t.integer :discussion_id
      t.integer :level_1_id
      t.integer :level_2_id
      t.integer :level_3_id
      t.integer :level_4_id
      t.integer :level_5_id
      t.timestamps
    end
  end
end
