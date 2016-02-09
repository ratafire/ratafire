class AddMajorpostUuidToAudio < ActiveRecord::Migration
  def change
  	add_column :audios, :majorpost_uuid, :string
  end
end
