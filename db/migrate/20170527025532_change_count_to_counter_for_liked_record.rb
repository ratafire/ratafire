class ChangeCountToCounterForLikedRecord < ActiveRecord::Migration
  def change
  	remove_column :liked_records, :count
  	add_column :liked_records, :counter, :integer, :default => 0
  end
end
