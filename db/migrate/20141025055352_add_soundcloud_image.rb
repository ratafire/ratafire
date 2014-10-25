class AddSoundcloudImage < ActiveRecord::Migration
  def up
  	add_column :audios, :soundcloud_image, :string
  end

  def down
  end
end
