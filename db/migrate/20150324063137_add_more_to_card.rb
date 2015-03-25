class AddMoreToCard < ActiveRecord::Migration
  def change
  	add_column :cards, :object, :string
  	add_column :cards, :cvc_check, :string
  	add_column :cards, :address_line1_check, :string
  	add_column :cards, :address_zip_check, :string
  	add_column :cards, :dynamic_last4, :string
  	add_column :cards, :deleted_at, :datetime
  	add_column :cards, :deleted, :boolean
  end
end
