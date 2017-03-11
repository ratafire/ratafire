class AddQuestsToLevelingup < ActiveRecord::Migration
  def change
  	add_column :level_xps, :quest_sm, :integer
  	add_column :level_xps, :quest, :integer
  	add_column :level_xps, :quest_lg, :integer
  end
end
