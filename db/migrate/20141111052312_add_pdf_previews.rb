class AddPdfPreviews < ActiveRecord::Migration
  def up
  	remove_attachment :pdfs, :pdf
  	add_attachment :pdfs, :pdf
  end

  def down
  end
end
