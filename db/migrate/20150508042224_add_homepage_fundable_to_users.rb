class AddHomepageFundableToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :homepage_fundable, :boolean
  	add_column :users, :fundable_show, :boolean
  end
end
