class CreateShippingAddresses < ActiveRecord::Migration
  def change
    create_table :shipping_addresses do |t|
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :uuid
    	t.integer :user_id
    	t.integer :campaign_id
    	t.integer :reward_id
    	t.integer :reward_receiver_id
    	t.string :country
    	t.string :city
    	t.string :line1
    	t.string :line2
    	t.string :first_name
    	t.string :last_name
    	t.string :postal_code
    	t.string :encrypted_postal_code
    	t.string :encrypted_postal_code_iv
    	t.string :state
      t.timestamps null: false
    end
    add_column :shippings, :reward_receiver_id, :integer
    add_column :reward_receivers, :uuid, :string
  end
end
