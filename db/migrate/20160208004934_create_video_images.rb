class CreateVideoImages < ActiveRecord::Migration
  def change
    create_table :video_images do |t|
      t.integer :user_id
      t.string :majorpost_id
      t.string :audio_id
      t.boolean :deleted
      t.datetime :deleted_at
      t.string :direct_upload_url
      t.string :uuid
  	  t.string :majorpost_uuid
  	  t.string :video_uuid
  	  t.boolean :skip_everafter
      t.timestamps null: false
    end
    add_attachment :video_images,:image
  end
end
