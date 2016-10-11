class CreateTagImages < ActiveRecord::Migration
  def change
    create_table :tag_images do |t|
    	t.integer :tag_id
    	t.string :uuid
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.boolean :processed, default: false, null: false
    	t.string :direct_upload_url
    	t.text :description
      t.timestamps null: false
    end
    add_attachment :tag_images, :image
    remove_column :tags, :direct_upload_url
    remove_column :tags, :processed
    remove_attachment :tags, :image
  end
end
