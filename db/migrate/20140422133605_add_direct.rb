class AddDirect < ActiveRecord::Migration
  def up
  	add_column :videos, :direct_upload_url, :string, :null => false
  end

  def down
  end
end
