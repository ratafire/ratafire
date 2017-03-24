class CreateAchievementRelationships < ActiveRecord::Migration
  def change
    create_table :achievement_relationships do |t|
    	t.integer :user_id
    	t.integer :achievement_id
      t.timestamps null: false
    end
  end
end
