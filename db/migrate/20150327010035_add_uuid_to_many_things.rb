class AddUuidToManyThings < ActiveRecord::Migration
  def change
  	add_column :billing_agreements, :uuid, :string
  	add_column :cards, :uuid, :string
  	add_column :customers, :uuid, :string
  end
end
