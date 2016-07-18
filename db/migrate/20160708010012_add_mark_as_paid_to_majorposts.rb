class AddMarkAsPaidToMajorposts < ActiveRecord::Migration
  def change
  	add_column :majorposts, :mark_as_paid, :boolean, :default => false
  end
end
