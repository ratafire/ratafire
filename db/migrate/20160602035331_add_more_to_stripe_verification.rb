class AddMoreToStripeVerification < ActiveRecord::Migration
  def change
  	add_column :stripe_accounts, :first_name, :string
  	add_column :stripe_accounts, :last_name, :string
  end
end
