class AddMajorpostUuidToVideo < ActiveRecord::Migration
  def change
  	add_column :videos, :majorpost_uuid, :string
  	add_column :videos, :uuid, :string
  end
end
