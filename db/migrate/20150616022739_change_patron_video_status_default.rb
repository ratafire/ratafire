class ChangePatronVideoStatusDefault < ActiveRecord::Migration
  def up
  	remove_column :patron_videos, :status 
  	add_column :patron_videos, :status, :string, :default => "Pending"
  end

  def down
  end
end
