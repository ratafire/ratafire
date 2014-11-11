class AddTempToPdf < ActiveRecord::Migration
  def change
  	add_column :pdfs, :content_temp, :text
  	add_column :pdfs, :tags_temp, :text
  end
end
