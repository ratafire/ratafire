class AddUuidToAudios < ActiveRecord::Migration
  def change
  	add_column :audios, :uuid, :string
  end
end
