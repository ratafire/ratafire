class AddPaypalEmailToCampaign < ActiveRecord::Migration
  def change
  	add_column :campaigns, :paypal_email, :string
  end
end
