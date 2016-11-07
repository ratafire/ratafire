class CreateTraits < ActiveRecord::Migration
  def change
    create_table :traits do |t|
    	t.integer :user_id
    	t.integer :trait_id
    	t.string :trait_name
    	t.boolean :deleted
    	t.datetime :deleted_at
		t.timestamps null: false
    end
  end
end
