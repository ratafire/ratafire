class AddPhoneToVenmo < ActiveRecord::Migration
  def change
  	add_column :venmos, :phone, :string
  end
end
