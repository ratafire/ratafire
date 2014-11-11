class AddPdfIdToProjectAndMajorposts < ActiveRecord::Migration
  def change
  	add_column :projects, :pdf_id, :integer
  	add_column :majorposts, :pdf_id, :integer
  	add_column :archives, :pdf_id, :integer
  	add_column :archives, :audio_id, :integer
  end
end
