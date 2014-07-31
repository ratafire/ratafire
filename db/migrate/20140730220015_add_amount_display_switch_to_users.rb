class AddAmountDisplaySwitchToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :amount_display_switch, :boolean, :default => false
  end
end
