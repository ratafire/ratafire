class CreateShippingOrders < ActiveRecord::Migration
  def change
    create_table :shipping_orders do |t|
    	t.integer :user_id
    	t.decimal :amount, precision: 10, scale: 2, default: 0.0
    	t.boolean :transacted
    	t.datetime :transacted_at
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.integer :count
    	t.string :uuid
    	t.string :status
    	t.string :currency
    	t.string :city
    	t.string :country
    	t.string :line1
    	t.string :line2
    	t.string :first_name
    	t.string :last_name
    	t.string :postal_code
    	t.string :state
    	t.integer :reward_id
      t.timestamps null: false
    end
    add_column :transactions, :shipping_order_id, :integer
  end
end
