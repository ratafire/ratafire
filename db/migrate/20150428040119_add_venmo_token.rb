class AddVenmoToken < ActiveRecord::Migration
  def up
  	add_column :transactions, :venmo_username, :string
  	add_column :transactions, :venmo_token, :string
  end

  def down
  end
end
