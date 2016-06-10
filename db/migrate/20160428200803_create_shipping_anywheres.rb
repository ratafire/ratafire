class CreateShippingAnywheres < ActiveRecord::Migration
  def change
    create_table :shipping_anywheres do |t|
    	t.string :uuid
    	t.integer :campaign_id
    	t.integer :user_id
    	t.decimal :amount, default: 0.0, precision: 10, scale: 2 
    	t.integer :reward_id
    	t.boolean :deleted
    	t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
