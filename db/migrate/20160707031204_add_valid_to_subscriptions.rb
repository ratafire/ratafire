class AddValidToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscription_records, :is_valid, :string, :default => false
  end
end
