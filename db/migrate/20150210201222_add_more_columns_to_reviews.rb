class AddMoreColumnsToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :status, :string
  end
end
