class CreateTraitRelationships < ActiveRecord::Migration
  def change
    create_table :trait_relationships do |t|
    	t.string :uuid
    	t.integer :user_id
    	t.integer :trait_id
    	t.datetime :deleted_at
    	t.boolean :deleted
    	t.timestamps null: false
    end
  end
end
