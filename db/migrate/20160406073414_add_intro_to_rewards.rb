class AddIntroToRewards < ActiveRecord::Migration
  def change
  	add_column :rewards, :intro, :boolean
  end
end
