class AddBioLocationBioHtml < ActiveRecord::Migration
  def up
  	add_column :users, :location, :string
  	add_column :users, :bio_html, :string
  end

  def down
  end
end
