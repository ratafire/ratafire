class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :customer_id
      t.string :object
      t.boolean :livemode
      t.integer :account_balance
      t.string :currency
      t.string :default_source
      t.boolean :delinquent
      t.string :description
      t.string :email
   	  t.integer :user_id
   	  t.datetime :deleted_at
   	  t.boolean :deleted
      t.timestamps
    end
    add_column :cards, :customer_stripe_id, :string
    add_column :cards, :card_stripe_id, :string
  end
end
