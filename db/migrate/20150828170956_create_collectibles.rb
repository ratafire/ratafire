class CreateCollectibles < ActiveRecord::Migration
  def change
    create_table :collectibles do |t|
    	t.integer :project_id
    	t.integer :user_id
    	t.integer :facebookpage_id
    	t.integer :level
    	t.text :content
    	t.boolean :deleted
    	t.datetime :deleted_at
      t.timestamps
    end
  end
end
