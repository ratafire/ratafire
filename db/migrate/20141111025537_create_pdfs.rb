class CreatePdfs < ActiveRecord::Migration
  def change
    create_table :pdfs do |t|
      t.string :title
      t.integer :majorpost_id
      t.integer :project_id
      t.string :thumbnail_file_name
      t.string :thumbnail_content_type
      t.integer :thumbnail_file_size
      t.datetime :thumbnail_updated_at
      t.string :pdf_file_name
      t.string :pdf_content_type
      t.integer :pdf_file_size
      t.datetime :pdf_updated_at
      t.integer :archive_id
      t.string :direct_upload_url, :null => false
      t.boolean :processed, :default => false, :null => false
      t.integer :user_id, :null => false
      t.boolean :skip_everafter, :default => false
      t.timestamps
    end
  end
end
