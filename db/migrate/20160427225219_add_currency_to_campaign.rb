class AddCurrencyToCampaign < ActiveRecord::Migration
  def change
  	add_column :campaigns, :currency, :string
  end
end
