class AddNewGoalsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :goals_watching, :integer, :default => 10
  	add_column :users, :goals_reviews, :integer, :default => 10
  end
end
