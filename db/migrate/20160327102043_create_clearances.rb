class CreateClearances < ActiveRecord::Migration
  def change
    create_table :clearances do |t|
    	t.integer :user_id
    	t.datetime :deleted_at
    	t.boolean :deleted
    	t.boolean :historical_quotes
    	t.string :uuid
      t.timestamps null: false
    end
  end
end
