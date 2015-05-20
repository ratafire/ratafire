class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.decimal :amount, :default => 0, :precision => 10, :scale => 2
      t.boolean :transacted
      t.datetime :transacted_at
      t.boolean :deleted
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
