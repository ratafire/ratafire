class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.string :audio
      t.integer :majorpost_id
      t.integer :project_id
      t.text :content_temp
      t.text :tags_temp
      t.integer :archive_id
      t.string :direct_upload_url,                     :null => false
      t.boolean  :processed,         :default => false, :null => false
      t.integer  :user_id,                              :null => false      
      t.timestamps
    end
  end
end
