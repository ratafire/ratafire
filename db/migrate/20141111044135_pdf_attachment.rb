class PdfAttachment < ActiveRecord::Migration
  def up
  	remove_column :pdfs, :thumbnail_file_name
  	remove_column :pdfs, :thumbnail_content_type
  	remove_column :pdfs, :thumbnail_file_size
  	remove_column :pdfs, :thumbnail_updated_at
  	remove_column :pdfs, :pdf_file_name
  	remove_column :pdfs, :pdf_content_type
  	remove_column :pdfs, :pdf_file_size
  	remove_column :pdfs, :pdf_updated_at
  	add_attachment :pdfs, :pdf
  end

  def down
  end
end
