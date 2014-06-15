class AddSupporterNumberToUser < ActiveRecord::Migration
  def change
  	add_column :users, :supporter_slot, :integer, :default => 5
  end
end
