class CreateRewardUploads < ActiveRecord::Migration
  def change
    create_table :reward_uploads do |t|
    	t.integer :user_id
    	t.integer :reward_id
    	t.integer :campaign_id
    	t.string :uuid
    	t.integer :count
    	t.boolean :deleted
    	t.datetime :deleted_at
      t.boolean :skip_ever_after
      t.timestamps null: false
    end
    add_attachment :reward_uploads, :package
  end
end
