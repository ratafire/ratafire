class AddCreatorToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :creator, :boolean
  	add_column :users, :creator_at, :datetime
  end
end
