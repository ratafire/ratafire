class AddRecipientDetails < ActiveRecord::Migration
  def up
  	add_column :subscription_applications, :ssn, :integer
  	add_column :users, :legalname, :string
  	add_column :subscription_applications, :routing_number, :integer
  	add_column :subscription_applications, :account_number, :integer
  	add_column :users, :ssn, :integer
  end

  def down
  end
end
