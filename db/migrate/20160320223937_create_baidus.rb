class CreateBaidus < ActiveRecord::Migration
  def change
    create_table :baidus do |t|
    	t.datetime :deleted_at
    	t.integer :user_id
    	t.boolean :deleted
    	t.string :uuid
    	t.text :test
      t.timestamps null: false
    end
  end
end
