class CreateRenrens < ActiveRecord::Migration
  def change
    create_table :renrens do |t|
    	t.text :test
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.integer :user_id
    	t.string :uuid
      t.timestamps null: false
    end
  end
end
