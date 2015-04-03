class AddNewToReview < ActiveRecord::Migration
  def change
  	add_column :reviews, :skip_countdown, :boolean, :default => false
  end
end
