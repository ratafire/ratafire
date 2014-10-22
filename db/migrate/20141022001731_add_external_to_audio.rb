class AddExternalToAudio < ActiveRecord::Migration
  def change
  	add_column :audios,:soundcloud, :string
  end
end
