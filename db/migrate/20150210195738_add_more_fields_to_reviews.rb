class AddMoreFieldsToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :deleted_at, :datetime
  	add_column :reviews, :deleted, :boolean
  	add_column :reviews, :message, :text
  end
end
