class AddExpirationsToVenmo < ActiveRecord::Migration
  def change
  	add_column :venmos, :refresh_token, :string
  	add_column :venmos, :expires_in, :string
  end
end
