class CreatePatronVideos < ActiveRecord::Migration
  def change
    create_table :patron_videos do |t|
      t.boolean :deleted
      t.boolean :deleted_at
      t.integer :user_id
      t.integer :video_id
      t.text :review
      t.string :status
      t.integer :admin_id
      t.timestamps
    end
  end
end
