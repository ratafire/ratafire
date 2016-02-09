class ChangeAudioTitleType < ActiveRecord::Migration
  def change
  	change_column :audios, :title, :text
  end
end
