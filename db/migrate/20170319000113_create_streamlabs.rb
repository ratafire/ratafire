class CreateStreamlabs < ActiveRecord::Migration
  def change
    create_table :streamlabs do |t|
    	t.string :uuid
    	t.integer :user_id
    	t.string :streamlab_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.text :test
      t.timestamps null: false
    end
  end
end
