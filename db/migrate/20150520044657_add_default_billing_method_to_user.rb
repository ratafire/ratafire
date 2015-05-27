class AddDefaultBillingMethodToUser < ActiveRecord::Migration
  def change
  	add_column :users, :default_billing_method, :string
  end
end
