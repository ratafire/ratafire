class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
    	t.integer  :backer_id
    	t.integer  :backed_id
    	t.decimal :amount, precision: 10, scale: 2
  		t.datetime :deleted_at
  		t.decimal :accumulated_receive, precision: 10, scale: 2
   		t.decimal :accumulated_ratafire, precision: 10, scale: 2
    	t.decimal :accumulated_total, precision: 10, scale: 2
   		t.integer :subscription_record_id
   		t.integer :project_id
   		t.integer :deleted_reason
   		t.datetime :activated_at
   		t.boolean :activated
   		t.boolean :deleted
        t.text :uuid
        t.integer :counter
        t.integer :facebook_page_id
        t.integer :order_id
        t.decimal :accumulated_fee, precision: 10, scale: 2, default: 0.0
        t.timestamps null: false
    end
  end
end
