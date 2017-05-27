class CreateLikedRecords < ActiveRecord::Migration
  def change
    create_table :liked_records do |t|
    	t.boolean :deleted
    	t.integer :liker_id
    	t.integer :liked_id
    	t.integer :count
    	t.datetime :deleted_at
    	t.boolean :active, :default => false
      t.timestamps null: false
    end
  end
end
