class CreateAudioImages < ActiveRecord::Migration
  def change
    create_table :audio_images do |t|
      t.integer :user_id
      t.string :majorpost_id
      t.string :audio_id
      t.boolean :deleted
      t.datetime :deleted_at
      t.string :direct_upload_url
      t.string :uuid
      t.timestamps null: false
    end
    add_attachment :audio_images, :image
  end
end
